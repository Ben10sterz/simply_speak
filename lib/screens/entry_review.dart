import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_speak/screens/home_page.dart';

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

  // just get todays date in the format we want it (without seconds)
  DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  void _endEntryGoHomePage() {
    // make our entryDao save this entry
    widget.entryDao.saveEntry();

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const Homepage(),
    ));
  }

  // gets the rating icon/emoji that the user previously selected
  String getIcon() {
    List<String> urlList = [
      'assets/images/Red Smiley.png',
      'assets/images/Red Orange Smiley.png',
      'assets/images/Orange Smiley.png',
      'assets/images/Yellow Green Smiley.png',
      'assets/images/Green Smiley.png'
    ];

    // minus 1 because arrays go to 0 and our database entry starts with 1
    return urlList[int.parse(widget.entryDao.getRating()) - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Simply Speak'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                /////////////////////////////// Review entry at top of page
                Container(
                  height: 100.0,
                  width: 250.0,
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: const [
                      Text(
                        "Review your Entry",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ///////////////////////////////////// Title of their entry
                Container(
                  height: 100.0,
                  width: 300.0,
                  padding: const EdgeInsets.only(top: 0),
                  child: (SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const ScrollPhysics(),
                      child: Text(
                        widget.entryDao.getTitle(),
                        style: const TextStyle(
                          fontSize: 25,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.center,
                      ))),
                ),
                //////////////////////////////////// Entry area
                Container(
                  height: 850.0,
                  width: 350.0,
                  child: Column(
                    children: [
                      ////////////////////////////// 1st Entry
                      Container(
                          height: 40.0,
                          width: 330.0,
                          child: const Text(
                            "#1 Day Prompt",
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
                            child: Text(widget.entryDao.getPrompt(1),
                                style: const TextStyle(fontSize: 18),
                                textAlign: TextAlign.center))),
                      ),
                      const Spacer(),
                      //////////////////////////////////// 2nd Entry
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
                            child: Text(widget.entryDao.getPrompt(2),
                                style: const TextStyle(fontSize: 18),
                                textAlign: TextAlign.center))),
                      ),
                      const Spacer(),
                      ///////////////////////////////////// 3rd Entry
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
                            child: Text(widget.entryDao.getPrompt(3),
                                style: const TextStyle(fontSize: 18),
                                textAlign: TextAlign.center))),
                      ),
                      ///////////////////////////////////// Entry rating area
                      Container(
                          width: 330,
                          height: 125,
                          padding: const EdgeInsets.only(top: 30),
                          child: Image(
                            width: 50,
                            height: 50,
                            image: AssetImage(getIcon()),
                          )),
                      const Spacer(),
                      //////////////////////////////////////////// Save button area
                      Container(
                          height: 100.0,
                          width: 330.0,
                          padding: const EdgeInsets.only(top: 0),
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                              onPressed: _endEntryGoHomePage,
                              child: const Icon(Icons.save),
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(75, 50)))),
                      Container(
                          height: 100.0,
                          width: 330.0,
                          padding: const EdgeInsets.only(top: 10),
                          child: const Text(
                              "NOTICE!\n You will be unable to make changes after saving.",
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.center)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
