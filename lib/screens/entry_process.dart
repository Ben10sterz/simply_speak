import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class EntryProcessScreen extends StatefulWidget {
  EntryProcessScreen({Key? key}) : super(key: key);
  @override
  _EntryProcessScreenState createState() => _EntryProcessScreenState();
}

class _EntryProcessScreenState extends State<EntryProcessScreen> {
  String title = "Test text";

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String _fullSentence = '';

  int count = 0;
  int _fullLength = 0;
  List<int> _lastLength = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      count++;
      print(
          "Count: " + count.toString() + " Result: " + result.recognizedWords);
      _lastWords = result.recognizedWords;
    });

    if (_speechToText.isNotListening) {
      print("Stopped listening here");
      //print("Full Recognized:" + result.recognizedWords);
      _fullSentence += result.recognizedWords;
      _lastLength.add(_lastWords.length);
      _fullLength += _lastLength.last;
      print(_fullSentence.characters
          .take(_fullLength - _lastLength.last)
          .toString());
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
    _fullSentence = _fullSentence.characters
        .take(_fullLength - _lastLength.last)
        .toString();

    _fullLength -= _lastLength.last;
    _lastLength.removeLast();
    setState(() {});
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
              child: Column(
                children: [
                  Text(
                    "Prompt #1",
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    "This is where the prompt selection would be!",
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    child: Text(
                      '$_fullSentence',
                      style: TextStyle(fontSize: 15),
                    ),
                    padding: const EdgeInsets.all(8.0),
                  ),
                  Text((_speechToText.isListening
                          ? '$_lastWords'
                          : _speechEnabled
                              ? 'Tap the microphone to start listening...'
                              : 'Speech not available')
                      .toString()),
                  ElevatedButton(
                      onPressed: _speechToText.isNotListening
                          ? _startListening
                          : _stopListening,
                      child: Icon(_speechToText.isNotListening
                          ? Icons.mic_off
                          : Icons.mic)),
                  ElevatedButton(
                      onPressed: _deleteLast, child: Icon(Icons.backspace)),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
