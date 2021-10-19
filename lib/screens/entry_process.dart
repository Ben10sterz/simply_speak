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
      _lastWords = result.recognizedWords;
      _fullSentence += _lastWords;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simply Speak'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Column(),
            ),
            Container(
              child: Column(
                children: [
                  Text("Enter"),
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
