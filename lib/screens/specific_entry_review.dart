import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:simply_speak/database/entry_class.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../database/entry_class_dao.dart';

class SpecificEntryReview extends StatefulWidget {
  final EntryDao entryDao;
  final DateTime selectedDate;
  const SpecificEntryReview(
      {Key? key, required this.entryDao, required this.selectedDate})
      : super(key: key);

  @override
  _SpecificEntryReviewState createState() => _SpecificEntryReviewState();
}

class _SpecificEntryReviewState extends State<SpecificEntryReview> {
  final user = FirebaseAuth.instance.currentUser;

  // initializing our Entry object as empty
  Entry entry = Entry('', '', '', '', '', '');
  @override
  void initState() {
    _retrieveEntry(widget.selectedDate);
  }

  // same as entry_review.dart, gets our users rating url for this entry
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

  // function to wait half a second for our database to grab our entries
  Future<bool> testFuture() async {
    await Future.delayed(const Duration(seconds: 1), () => "5");
    return Future<bool>.value(true);
  }

  // get the specific entry on the date provided
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
          title: const Text('Simply Speak'),
        ),
        body: FutureBuilder(
            future: testFuture(),
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  child: Center(
                    child: Column(
                      children: [
                        //////////////////////////////////// Title area
                        Container(
                          height: 100.0,
                          width: 300.0,
                          padding: const EdgeInsets.only(top: 30),
                          child: (SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              physics: const ScrollPhysics(),
                              child: Text(
                                entry.title,
                                style: const TextStyle(
                                  fontSize: 25,
                                  decoration: TextDecoration.underline,
                                ),
                                textAlign: TextAlign.center,
                              ))),
                        ),
                        ////////////////////////////////////////// Prompts container
                        Container(
                          height: 850.0,
                          width: 350.0,
                          child: Column(
                            children: [
                              //////////////////////////////// 1st prompt
                              Container(
                                  height: 40.0,
                                  width: 330.0,
                                  child: const Text(
                                    "#1 Day Log Prompt",
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  )),
                              Container(
                                height: 100.0,
                                width: 300.0,
                                padding: const EdgeInsets.only(top: 0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: (SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    physics: const ScrollPhysics(),
                                    child: Text(entry.entryOne,
                                        style: const TextStyle(fontSize: 14),
                                        textAlign: TextAlign.center))),
                              ),
                              const Spacer(),
                              //////////////////////////////////////// 2nd prompt
                              Container(
                                  height: 60.0,
                                  width: 330.0,
                                  padding: const EdgeInsets.only(top: 20),
                                  child: const Text(
                                    "#2 Appreciation Prompt",
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  )),
                              Container(
                                height: 100.0,
                                width: 300.0,
                                padding: const EdgeInsets.only(top: 0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: (SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    physics: const ScrollPhysics(),
                                    child: Text(entry.entryTwo,
                                        style: const TextStyle(fontSize: 14),
                                        textAlign: TextAlign.center))),
                              ),
                              const Spacer(),
                              ////////////////////////////////////////// 3rd Prompt
                              Container(
                                  height: 60.0,
                                  width: 330.0,
                                  padding: const EdgeInsets.only(top: 20),
                                  child: const Text(
                                    "#3 Improvement Prompt",
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  )),
                              Container(
                                height: 100.0,
                                width: 300.0,
                                padding: const EdgeInsets.only(top: 0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: (SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    physics: const ScrollPhysics(),
                                    child: Text(entry.entryThree,
                                        style: const TextStyle(fontSize: 14),
                                        textAlign: TextAlign.center))),
                              ),
                              ////////////////////////////////////// Rating icon image
                              Container(
                                  width: 330,
                                  height: 125,
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Image(
                                    width: 50,
                                    height: 50,
                                    image: AssetImage(getIcon()),
                                    //size: 50,
                                  )),
                              const Spacer(),
                              /////////////////////////////////////////////// back button at the bottom
                              Container(
                                  height: 100.0,
                                  width: 330.0,
                                  padding: const EdgeInsets.only(top: 0),
                                  alignment: Alignment.bottomCenter,
                                  child: ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child:
                                          const Icon(Icons.arrow_back_rounded),
                                      style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(75, 50)))),
                              const Spacer()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
