import 'package:flutter/material.dart';
import 'package:simply_speak/screens/entry_review.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../database/entry_class_dao.dart';

class EntryRating extends StatefulWidget {
  final EntryDao entryDao;
  const EntryRating({Key? key, required this.entryDao}) : super(key: key);

  @override
  _EntryRatingState createState() => _EntryRatingState();
}

class _EntryRatingState extends State<EntryRating> {
  // get the current user
  final user = FirebaseAuth.instance.currentUser;

  // in case they skip through this page, the default rating is 3 or yellow
  String rating = '3';
  // this is used in the widget to show the currently selected rating
  List<bool> selectedRating = [false, false, true, false, false];

  void _saveRatingNextPage() {
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
        title: const Text('Simply Speak'),
      ),
      body: Container(
          child: Center(
        child: Column(
          children: [
            Container(
              height: 200.0,
              width: 250.0,
              padding: const EdgeInsets.only(top: 120),
              child: Column(
                children: const [
                  Text(
                    " ",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            //////////////////// Title ///////////////////
            Container(
              height: 100.0,
              width: 300.0,
              padding: const EdgeInsets.only(top: 0),
              child: Column(children: const [
                Text("Please give your \n day a rating",
                    style: TextStyle(fontSize: 22), textAlign: TextAlign.center)
              ]),
            ),
            ///////////// Container containing ratings
            Container(
              height: 330.0,
              width: 350.0,
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                children: [
                  Container(
                      height: 200.0,
                      width: 330.0,
                      padding: const EdgeInsets.only(top: 0),
                      child: Row(
                        children: [
                          //////////////////////////////////////////////////
                          Container(
                            decoration: BoxDecoration(
                                // if the selectedRating is true, the box decoration is blue, otherwise it's transparent
                                color: selectedRating[0]
                                    ? Colors.blue
                                    : Colors.transparent,
                                shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: () {
                                  // set the currently selected rating to this one
                                  setRating('1');
                                  // update the screen so we can see the currently selected
                                  setState(() {});
                                },
                                iconSize: 50,
                                splashColor: Colors.blue,
                                icon: Image.asset(
                                    'assets/images/Red Smiley.png')),
                          ),
                          ////////////////////////////////////////////////////// each of these boxes is coded the same
                          Container(
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
                          ///////////////////////////////////////////////
                          Container(
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
                          ////////////////////////////////////////////
                          Container(
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
                          ///////////////////////////////////////////////
                          Container(
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
                      )),
                  const Spacer(),
                  Container(
                      height: 100.0,
                      width: 330.0,
                      padding: const EdgeInsets.only(top: 0),
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              // save the rating and go to the next page
                              onPressed: _saveRatingNextPage,
                              child: const Icon(Icons.arrow_right_alt))
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
