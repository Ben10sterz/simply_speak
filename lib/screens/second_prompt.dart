// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../database/entry_class_dao.dart';

import 'third_prompt.dart';

class SecondPrompt extends StatefulWidget {
  final EntryDao entryDao;
  SecondPrompt({Key? key, required this.entryDao}) : super(key: key);

  @override
  _SecondPromptState createState() => _SecondPromptState();
}

class _SecondPromptState extends State<SecondPrompt> {
  var promptNumber = 2;

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String _fullSentence = '';

  int _fullLength = 0;
  // ignore: prefer_final_fields
  List<int> _lastLength = [];

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    _lastWords = '';
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
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

  void _sendEntryNextPage() {
    widget.entryDao.setPrompt(_fullSentence, promptNumber);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ThirdPrompt(
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
                        "Prompt #2",
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
                    Text("Talk about what\nyou appreciate.\n",
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center),
                    Text(
                        "What do you appreciate in your life? Did anything happen today that you might usually take for granted?",
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
                                  onPressed: _sendEntryNextPage,
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
