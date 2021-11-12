import 'package:flutter/material.dart';
import 'package:simply_speak/screens/entry_rating.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../database/entry_class_dao.dart';

class EntryTitle extends StatefulWidget {
  final EntryTestDao entryDao;
  EntryTitle({Key? key, required this.entryDao}) : super(key: key);

  @override
  _EntryTitleState createState() => _EntryTitleState();
}

class _EntryTitleState extends State<EntryTitle> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String _fullSentence = '';

  int count = 0;
  int _fullLength = 0;
  List<int> _lastLength = [];

  //final entryDao = EntryTestDao();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    //entryDao.setReference(user!.email!);
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    _lastWords = '';
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      count++;
      _lastWords = result.recognizedWords;
    });

    if (_speechToText.isNotListening) {
      _fullSentence += result.recognizedWords + ' ';
      _fullSentence = _fullSentence.toTitleCase();
      _lastLength.add(_lastWords.length + 1);
      _fullLength += _lastLength.last;
    }
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _deleteLast() async {
    if (_fullSentence != '') {
      _fullSentence = _fullSentence.characters
          .take(_fullLength - _lastLength.last)
          .toString();

      _fullLength -= _lastLength.last;
      _lastLength.removeLast();
      setState(() {});
    }
  }

  void _sendMessage() {
    widget.entryDao.setTitle(_fullSentence);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EntryRating(
        entryDao: widget.entryDao,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simply Speak'),
      ),
      body: Container(
          child: Center(
        child: Column(
          children: [
            Container(
              height: 200.0,
              width: 250.0,
              padding: EdgeInsets.only(top: 120),
              // decoration:
              //     BoxDecoration(border: Border.all(color: Colors.black)),
              child: Column(
                children: [
                  Text(
                    " ",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            Container(
              height: 100.0,
              width: 300.0,
              padding: EdgeInsets.only(top: 0),
              // decoration:
              //     BoxDecoration(border: Border.all(color: Colors.black)),
              child: Column(children: [
                Text("Enter a Title For Your Entry",
                    style: TextStyle(fontSize: 22), textAlign: TextAlign.center)
              ]),
            ),
            Container(
              height: 330.0,
              width: 350.0,
              padding: EdgeInsets.only(top: 50),
              // decoration:
              //     BoxDecoration(border: Border.all(color: Colors.black)),
              child: Column(
                children: [
                  Container(
                    height: 100.0,
                    width: 330.0,
                    padding: EdgeInsets.only(top: 0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      child: Text(
                        (_speechToText.isListening
                                ? '$_fullSentence' '$_lastWords'
                                : _speechEnabled
                                    ? '$_fullSentence'
                                    : 'Speech not available')
                            .toString(),
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                      //padding: const EdgeInsets.all(8.0),
                    ),
                  ),
                  // Text((_speechToText.isListening
                  //         ? '$_fullSentence' '$_lastWords'
                  //         : _speechEnabled
                  //             ? 'Tap the microphone to start listening...'
                  //             : 'Speech not available')
                  //     .toString()),
                  Spacer(),
                  Container(
                      height: 100.0,
                      width: 330.0,
                      padding: EdgeInsets.only(top: 0),
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.black)),
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: _deleteLast,
                              child: Icon(Icons.backspace)),
                          Container(
                              height: 65.0,
                              width: 85.0,
                              padding: EdgeInsets.only(top: 0),
                              child: ElevatedButton(
                                  onPressed: _speechToText.isNotListening
                                      ? _startListening
                                      : _stopListening,
                                  child: Icon(_speechToText.isNotListening
                                      ? Icons.mic
                                      : Icons.mic_off),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      primary: _speechToText.isListening
                                          ? Colors.red
                                          : Colors.blue))),
                          ElevatedButton(
                              onPressed: _sendMessage,
                              child: Icon(Icons.arrow_right_alt)
                              // ElevatedButton(
                              //   onPressed: () => entryDao.checkForVal(),
                              //   child: Text('Check'),
                              // )
                              )
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String toTitleCase() => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.toCapitalized())
      .join(" ");
}
