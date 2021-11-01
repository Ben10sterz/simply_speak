import 'package:flutter/material.dart';
import 'package:simply_speak/screens/entry_review.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../database/entry_class_dao.dart';

class EntryRating extends StatefulWidget {
  final EntryTestDao entryDao;
  EntryRating({Key? key, required this.entryDao}) : super(key: key);

  @override
  _EntryRatingState createState() => _EntryRatingState();
}

class _EntryRatingState extends State<EntryRating> {
  final user = FirebaseAuth.instance.currentUser;

  String rating = '';

  List<bool> selectedRating = [false, false, false, false, false];

  void _sendMessage() {
    widget.entryDao.setRating(rating);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EntryReview(
        entryDao: widget.entryDao,
      ),
    ));
  }

  void setRating(String choice) {
    rating = choice;
    selectedRating = [false, false, false, false, false];
    selectedRating[int.parse(choice) - 1] = true;
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
                Text("Please give your \n day a rating",
                    style: TextStyle(fontSize: 22), textAlign: TextAlign.center)
              ]),
            ),
            Container(
              height: 330.0,
              width: 350.0,
              padding: EdgeInsets.only(top: 0),
              // decoration:
              //     BoxDecoration(border: Border.all(color: Colors.black)),
              child: Column(
                children: [
                  Container(
                      height: 200.0,
                      width: 330.0,
                      padding: EdgeInsets.only(top: 0),
                      child: Row(
                        children: [
                          Container(
                            //color: Colors.green,
                            decoration: BoxDecoration(
                                color: selectedRating[0]
                                    ? Colors.blue
                                    : Colors.transparent,
                                shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: () {
                                  setRating('1');
                                  setState(() {});
                                },
                                iconSize: 50,
                                splashColor: Colors.blue,
                                icon: Image.asset(
                                    'assets/images/Red Smiley.png')),
                          ),
                          Container(
                            //color: Colors.green,
                            decoration: BoxDecoration(
                                color: selectedRating[1]
                                    ? Colors.blue
                                    : Colors.transparent,
                                shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: () {
                                  setRating('2');
                                  setState(() {});
                                },
                                iconSize: 50,
                                splashColor: Colors.blue,
                                icon: Image.asset(
                                    'assets/images/Red Orange Smiley.png')),
                          ),
                          Container(
                            //color: Colors.green,
                            decoration: BoxDecoration(
                                color: selectedRating[2]
                                    ? Colors.blue
                                    : Colors.transparent,
                                shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: () {
                                  setRating('3');
                                  setState(() {});
                                },
                                iconSize: 50,
                                splashColor: Colors.blue,
                                icon: Image.asset(
                                    'assets/images/Orange Smiley.png')),
                          ),
                          Container(
                            //color: Colors.green,
                            decoration: BoxDecoration(
                                color: selectedRating[3]
                                    ? Colors.blue
                                    : Colors.transparent,
                                shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: () {
                                  setRating('4');
                                  setState(() {});
                                },
                                iconSize: 50,
                                splashColor: Colors.blue,
                                icon: Image.asset(
                                    'assets/images/Yellow Green Smiley.png')),
                          ),
                          Container(
                            //color: Colors.green,
                            decoration: BoxDecoration(
                                color: selectedRating[4]
                                    ? Colors.blue
                                    : Colors.transparent,
                                shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: () {
                                  setRating('5');
                                  setState(() {});
                                },
                                iconSize: 50,
                                splashColor: Colors.blue,
                                icon: Image.asset(
                                    'assets/images/Green Smiley.png')),
                          )
                        ],
                      )
                      //padding: const EdgeInsets.all(8.0),

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
                          // ElevatedButton(
                          //     onPressed: _deleteLast,
                          //     child: Icon(Icons.backspace)),
                          // Container(
                          //     height: 65.0,
                          //     width: 85.0,
                          //     padding: EdgeInsets.only(top: 0),
                          //     child: ElevatedButton(
                          //         onPressed: _speechToText.isNotListening
                          //             ? _startListening
                          //             : _stopListening,
                          //         child: Icon(_speechToText.isNotListening
                          //             ? Icons.mic
                          //             : Icons.mic_off),
                          //         style: ElevatedButton.styleFrom(
                          //             shape: CircleBorder()))),
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
