// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:simply_speak/screens/entry_title.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../database/entry_test.dart';
import '../database/entry_class_dao.dart';
import '../api/google_sign_in_2.dart';

import 'first_prompt.dart';

class ThirdPrompt extends StatefulWidget {
  final EntryTestDao entryDao;
  ThirdPrompt({Key? key, required this.entryDao}) : super(key: key);

  @override
  _ThirdPromptState createState() => _ThirdPromptState();
}

class _ThirdPromptState extends State<ThirdPrompt> {
  var promptNumber = 3;

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
    widget.entryDao.setPrompt(_fullSentence, promptNumber);
    // final message = EntryTest('testPurposes', DateTime.now());
    // entryDao.saveEntry(message);
    //widget.entryDao.printList();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EntryTitle(
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ScrollPhysics(),
          child: Container(
              child: Center(
            child: Column(
              children: [
                Container(
                  height: 150.0,
                  width: 250.0,
                  padding: EdgeInsets.only(top: 60),
                  // decoration:
                  //     BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Column(
                    children: [
                      Text(
                        "Prompt #3",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200.0,
                  width: 300.0,
                  padding: EdgeInsets.only(top: 0),
                  // decoration:
                  //     BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Column(children: [
                    Text("Talk about\nself-improvement.\n",
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center),
                    Text(
                        "What do you wish to improve upon? Could you have done anything better today?",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center)
                  ]),
                ),
                Container(
                  height: 330.0,
                  width: 350.0,
                  padding: EdgeInsets.only(top: 10),
                  // decoration:
                  //     BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Column(
                    children: [
                      Container(
                        height: 150.0,
                        width: 330.0,
                        padding: EdgeInsets.only(top: 0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
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
                            style: TextStyle(fontSize: 15),
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
                      Container(
                        height: 20.0,
                      ),
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
        ));
  }
}
