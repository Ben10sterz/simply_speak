import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_speak/screens/home_page.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../database/entry_class_dao.dart';

class EntryReview extends StatefulWidget {
  final EntryDao entryDao;
  EntryReview({Key? key, required this.entryDao}) : super(key: key);

  @override
  _EntryReviewState createState() => _EntryReviewState();
}

class _EntryReviewState extends State<EntryReview> {
  final user = FirebaseAuth.instance.currentUser;
  DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  void setPreferencesAndTodaysDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("lastEntry", today.toString());
  }

  void _sendMessage() {
    setPreferencesAndTodaysDate();
    widget.entryDao.saveEntry();

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => Homepage(),
    ));
  }

  String getIcon() {
    List<String> urlList = [
      'assets/images/Red Smiley.png',
      'assets/images/Red Orange Smiley.png',
      'assets/images/Orange Smiley.png',
      'assets/images/Yellow Green Smiley.png',
      'assets/images/Green Smiley.png'
    ];
    print(urlList[int.parse(widget.entryDao.getRating()) - 1]);
    return urlList[int.parse(widget.entryDao.getRating()) - 1];
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
                  height: 100.0,
                  width: 250.0,
                  padding: EdgeInsets.only(top: 20),
                  // decoration:
                  //     BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Column(
                    children: [
                      Text(
                        "Review your Entry",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                  child: (SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      child: Text(
                        widget.entryDao.getTitle(),
                        style: TextStyle(
                          fontSize: 25,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.center,
                      ))),
                ),
                Container(
                  height: 850.0,
                  width: 350.0,
                  //padding: EdgeInsets.only(top: 0),
                  // decoration:
                  //     BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Column(
                    children: [
                      Container(
                          height: 40.0,
                          width: 330.0,
                          //padding: EdgeInsets.only(top: 0),
                          // decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.black)),
                          child: Text(
                            "This is the area for prompt #1",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          )),
                      Container(
                        height: 100.0,
                        width: 300.0,
                        padding: EdgeInsets.only(top: 0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: (SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(),
                            child: Text(widget.entryDao.getPrompt(1),
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center))),
                      ),
                      Spacer(),
                      Container(
                          height: 60.0,
                          width: 330.0,
                          padding: EdgeInsets.only(top: 20),
                          // decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.black)),
                          child: Text(
                            "This is the area for prompt #2",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          )),
                      Container(
                        height: 100.0,
                        width: 300.0,
                        padding: EdgeInsets.only(top: 0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: (SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(),
                            child: Text(widget.entryDao.getPrompt(2),
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center))),
                      ),
                      Spacer(),
                      Container(
                          height: 60.0,
                          width: 330.0,
                          padding: EdgeInsets.only(top: 20),
                          // decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.black)),
                          child: Text(
                            "This is the area for prompt #3",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          )),
                      Container(
                        height: 100.0,
                        width: 300.0,
                        padding: EdgeInsets.only(top: 0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: (SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(),
                            child: Text(widget.entryDao.getPrompt(3),
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center))),
                      ),
                      Container(
                          width: 330,
                          height: 125,
                          // decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.black)),
                          padding: EdgeInsets.only(top: 30),
                          child: Image(
                            width: 50,
                            height: 50,
                            image: AssetImage(getIcon()),
                            //size: 50,
                          )),
                      Spacer(),
                      Container(
                          height: 100.0,
                          width: 330.0,
                          padding: EdgeInsets.only(top: 0),
                          // decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.black)),
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                              onPressed: _sendMessage,
                              child: Icon(Icons.save),
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(75, 50))
                              // ElevatedButton(
                              //   onPressed: () => entryDao.checkForVal(),
                              //   child: Text('Check'),
                              // )
                              )),
                      Container(
                          height: 100.0,
                          width: 330.0,
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                              "WARNING!\n You will be unable to make changes after saving.",
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.center)),
                    ],
                  ),
                )
              ],
            ),
          )),
        ));
  }
}
