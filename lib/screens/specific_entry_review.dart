import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:simply_speak/database/entry_class.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../database/entry_class_dao.dart';

class SpecificEntryReview extends StatefulWidget {
  final EntryDao entryDao;
  final DateTime selectedDate;
  SpecificEntryReview(
      {Key? key, required this.entryDao, required this.selectedDate})
      : super(key: key);

  @override
  _SpecificEntryReviewState createState() => _SpecificEntryReviewState();
}

class _SpecificEntryReviewState extends State<SpecificEntryReview> {
  final user = FirebaseAuth.instance.currentUser;

  Entry entry = Entry('', '', '', '', '', '');
  @override
  void initState() {
    _retrieveEntry(widget.selectedDate);
  }

  String getIcon() {
    List<String> urlList = [
      'assets/images/Red Smiley.png',
      'assets/images/Red Orange Smiley.png',
      'assets/images/Orange Smiley.png',
      'assets/images/Yellow Green Smiley.png',
      'assets/images/Green Smiley.png'
    ];
    return urlList[int.parse(entry.rating) - 1];
  }

  //late Entry entry;

  Future<bool> testFuture() async {
    await Future.delayed(const Duration(seconds: 1), () => "5");
    return Future<bool>.value(true);
  }

  void _retrieveEntry(DateTime selectedDate) {
    FirebaseDatabase.instance
        .reference()
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once()
        .then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      for (var entries in values.values) {
        final message = Entry.fromJson(entries);
        var splitDate = message.date.split('-');

        if (int.parse(splitDate[0]) == selectedDate.year) {
          if (int.parse(splitDate[1]) == selectedDate.month) {
            if (int.parse(splitDate[2]) == selectedDate.day) {
              entry = message;
              print(entry.entryOne);
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Simply Speak'),
        ),
        body: FutureBuilder(
            future: testFuture(),
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  child: Container(
                      child: Center(
                    child: Column(
                      children: [
                        Container(
                          height: 100.0,
                          width: 300.0,
                          padding: EdgeInsets.only(top: 30),
                          // decoration:
                          //     BoxDecoration(border: Border.all(color: Colors.black)),
                          child: (SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              physics: ScrollPhysics(),
                              child: Text(
                                entry.title,
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
                                    "#1 Day Log Prompt",
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
                                    child: Text(entry.entryOne,
                                        style: TextStyle(fontSize: 14),
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
                                    "#2 Appreciation Prompt",
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
                                    child: Text(entry.entryTwo,
                                        style: TextStyle(fontSize: 14),
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
                                    "#3 Improvement Prompt",
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
                                    child: Text(entry.entryThree,
                                        style: TextStyle(fontSize: 14),
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
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Icon(Icons.arrow_back_rounded),
                                      style: ElevatedButton.styleFrom(
                                          fixedSize: Size(75, 50))
                                      // ElevatedButton(
                                      //   onPressed: () => entryDao.checkForVal(),
                                      //   child: Text('Check'),
                                      // )
                                      )),
                              Spacer()
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                );
              } else {
                print("doesn it ever ggo here");
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
