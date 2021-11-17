// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../database/entry_class_dao.dart';

import 'second_prompt.dart';

class FirstPrompt extends StatefulWidget {
  final EntryDao entryDao;
  FirstPrompt({Key? key, required this.entryDao}) : super(key: key);

  @override
  _FirstPromptState createState() => _FirstPromptState();
}

class _FirstPromptState extends State<FirstPrompt> {
  // just keeping track of what prompt this is for database
  var promptNumber = 1;

  // initialize the speech to text user-made function/tool
  final SpeechToText _speechToText = SpeechToText();
  // currently not listening
  bool _speechEnabled = false;

  // the last entire sentence that the user spoke
  String _lastWords = '';
  // the entire sentence/sentences the user has said so far
  String _fullSentence = '';

  // used for the length of the last sentence user spoke
  int _fullLength = 0;

  // ignore: prefer_final_fields
  List<int> _lastLength = [];

  // get the current user
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // initialize the speech function
    _initSpeech();
  }

  void _startListening() async {
    // start listening to the user, when done run _onSpeechResult
    await _speechToText.listen(onResult: _onSpeechResult);

    // reset the last words said to get ready for the next sentence
    _lastWords = '';

    // update the app
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });

    // if we're sure the app is done listening
    if (_speechToText.isNotListening) {
      // add the last thing the user said to the continuous full sentence
      // adding a space at the end so that letters don't touch eachother for each sentence
      _fullSentence += result.recognizedWords + ' ';

      // keep track of the length of that last sentence, so that we can delete it if needed
      _lastLength.add(_lastWords.length + 1);

      // keeping track of the entire lenght of the list
      _fullLength += _lastLength.last;
    }
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  ///
  /// happens when the user presses the mic button to stop listening rather than it timing out
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// speech to text initialization
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  // this is the function called when the user backspaces to delete the last sentence they said
  void _deleteLast() async {
    // if the full sentence has not already been deleted all the way
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
    // only happens on first entry, making sure the current entry list is empty
    widget.entryDao.resetEntryList();

    // add the current fullsentence to our entry object
    widget.entryDao.setPrompt(_fullSentence, 1);

    // go to the next page of second prompt
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SecondPrompt(
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
        // make the page scrollable in case it fit's differently on different devices
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                ////////////////////////////////// Title
                Container(
                  height: 150.0,
                  width: 250.0,
                  padding: EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Text(
                        "Prompt #1",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 150.0,
                  width: 300.0,
                  padding: EdgeInsets.only(top: 0),
                  child: Column(children: [
                    Text("Talk about your day.\n",
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center),
                    Text(
                        "Did you do anything special? How did you feel throughout the day? What brought you joy or displeasure?",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center)
                  ]),
                ),
                //////////////////////// speech to text container
                Container(
                  height: 330.0,
                  width: 350.0,
                  padding: EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      Container(
                        height: 150.0,
                        width: 330.0,
                        padding: EdgeInsets.only(top: 0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        // make it so that you can scroll within the box
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(),
                          child: Text(
                            // this will automatically update when setState is called to show what the user is saying
                            (_speechToText.isListening
                                    ? '$_fullSentence' '$_lastWords'
                                    : _speechEnabled
                                        ? '$_fullSentence'
                                        : 'Speech not available')
                                .toString(),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Spacer(),
                      ///////////////////////////////////////// Buttons on the bottom
                      Container(
                          height: 100.0,
                          width: 330.0,
                          padding: EdgeInsets.only(top: 0),
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
                                      // the buttons function, icon and style depend on whether the app is listening
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
                                  child: Icon(Icons.arrow_right_alt))
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
