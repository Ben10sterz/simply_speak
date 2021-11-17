// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:simply_speak/database/entry_class.dart';
import 'package:simply_speak/database/entry_class_dao.dart';
import 'package:simply_speak/screens/first_prompt.dart';
import 'package:simply_speak/screens/information_page.dart';
import 'package:simply_speak/screens/specific_entry_review.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:intl/intl.dart';

import 'sign_in_page.dart';
import '../api/google_sign_in_2.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  initState() {
    // list of our emoji faces for our calendar widget
    facesList = [
      'assets/images/Red Smiley.png',
      'assets/images/Red Orange Smiley.png',
      'assets/images/Orange Smiley.png',
      'assets/images/Yellow Green Smiley.png',
      'assets/images/Green Smiley.png',
    ];

    // fetch the entries for our Calander widget
    _performEntryFetch();

    // fetches the entries in our one month span to get the number of each face
    _performOneMonthRatingFetch(
        DateTime.now().year.toString(), DateTime.now().month.toString());
  }

  // just initializing these variables / setting them to blank
  List<String> facesList = [];
  List<String> ratingsList = [];
  List<String> calendarList = [];
  List<int> insightRatingList = [
    0,
    0,
    0,
    0,
    0
  ]; // this array changes in accordance to the number of entries with that corresponding rating/face
  bool entryMadeToday = false; // was an entry made today
  PageController pageController = PageController(initialPage: 1);
  int currentIndex =
      1; // current Index of the pageviewer widget (that spans the entire home page)

  final user = FirebaseAuth.instance.currentUser;

  final EntryTestDao entryDao = EntryTestDao();

  void _performEntryFetch() {
    // set it to false first for each time this is run
    entryMadeToday = false;

    // this just gets all the entries
    FirebaseDatabase.instance
        .reference()
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once()
        .then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      for (var entries in values.values) {
        final message = Entry.fromJson(entries);
        // we need each individual part of the date so we need to split it up
        var splitDate = message.date.split('-');

        // calendarList is keeping track of the dates for the calendar widget
        calendarList.add(message.date);
        // ratingList is adding the rating/face at the same spot as calendarList
        ratingsList.add((int.parse(message.rating) - 1).toString());

        // might as well check if an entry has been made today too
        if (int.parse(splitDate[0]) == DateTime.now().year) {
          if (int.parse(splitDate[1]) == DateTime.now().month) {
            if (int.parse(splitDate[2]) == DateTime.now().day) {
              entryMadeToday = true;
            }
          }
        }
      }
    });
  }

  // same as above, but performing on just one month for our insights page
  // honestly could probably put this in our function above instead
  void _performOneMonthRatingFetch(String year, String month) {
    insightRatingList = [0, 0, 0, 0, 0];
    FirebaseDatabase.instance
        .reference()
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once()
        .then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      for (var entries in values.values) {
        final message = Entry.fromJson(entries);

        var splitDate = message.date.split('-');

        if (splitDate[0] == year) {
          if (splitDate[1] == month) {
            insightRatingList[int.parse(message.rating) - 1]++;
          }
        }
      }
    });
    //return insightRatingList;
  }

  // just a function to delay our app for half a second as it grabs entries
  Future<bool> testFuture() async {
    await Future.delayed(const Duration(milliseconds: 500), () => "5");
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) {
            pageController.animateToPage(value,
                duration: Duration(milliseconds: 250), curve: Curves.bounceIn);
            currentIndex = value;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "Calendar",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mic),
              label: "Record",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Insights",
            )
          ]),
      appBar: AppBar(
        title: Text('Simply Speak'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: <Widget>[
          TextButton(
              onPressed: () {
                // log out the user and tell the provider that's what we've done
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
              },
              child: Text("Logout",
                  style: TextStyle(
                    color: Colors.white,
                  ))),
          // avatar for photo in the top right
          CircleAvatar(backgroundImage: NetworkImage(user!.photoURL!)),
        ],
      ),
      body: FutureBuilder(
        future: testFuture(),
        builder: (context, snapshot) {
          // if/when the snapshot.data returns true, then build the below
          // other wise else is the spinning loading symbol
          if (snapshot.data == true) {
            return PageView(
              controller: pageController,
              onPageChanged: (page) {
                setState(() {
                  currentIndex = page;
                });
              },
              ///////////////////////////////////FIRST PAGE ////////////////////////////////////////////
              children: [
                Container(
                  color: Colors.white,
                  child: FutureBuilder(
                      future: testFuture(),
                      builder: (context, snapshot) {
                        if (snapshot.data == true) {
                          return Center(
                              heightFactor: 300.0,
                              child: TableCalendar(
                                calendarStyle:
                                    CalendarStyle(isTodayHighlighted: false),
                                headerStyle: HeaderStyle(
                                    titleCentered: true,
                                    formatButtonVisible: false),
                                rowHeight: 75.00,
                                daysOfWeekHeight: 20.00,
                                firstDay: DateTime(2021, 01, 01),
                                // last day is 5 years in the future
                                lastDay: DateTime.now()
                                    .add(const Duration(days: 5 * 365)),
                                focusedDay: DateTime.now(),
                                dayHitTestBehavior: HitTestBehavior.translucent,
                                calendarBuilders: CalendarBuilders(
                                    // customerizer for the calendar
                                    // lets us individual change each day within the calendar
                                    defaultBuilder: (context, day, currentDay) {
                                  var i = 0;
                                  for (var item in calendarList) {
                                    // for all days in the calendarList...
                                    var splitDate = item.split('-');
                                    if (day.year.toString() == splitDate[0]) {
                                      if (day.month.toString() ==
                                          splitDate[1]) {
                                        if (day.day ==
                                            int.parse(splitDate[2])) {
                                          return Column(
                                            // return a coolumn widget with...
                                            children: [
                                              IconButton(
                                                // an icon button (rating emoji)...
                                                icon: Image.asset(facesList[
                                                    int.parse(ratingsList[i])]),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        SpecificEntryReview(
                                                      entryDao: entryDao,
                                                      selectedDate: day,
                                                    ),
                                                  ));
                                                },
                                              ),
                                              Spacer(),
                                              Text(day.day
                                                  .toString()) // and the text of the day
                                            ],
                                          );
                                        }
                                      }
                                    }

                                    i++;
                                  } // otherwise if the date doesn't line up with a day in the calendar list
                                  // just return a column with ONLY a text widget
                                  return Column(
                                    children: [
                                      Spacer(),
                                      Text(day.day.toString())
                                    ],
                                  );
                                  // this builder was just to make the days outside the month look consistent
                                }, outsideBuilder: (context, day, currentDay) {
                                  return Column(
                                    children: [
                                      Spacer(),
                                      Text(
                                        day.day.toString(),
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  );
                                }),
                              ));
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
                ),
                ////////////////////////// SECOND PAGE /////////////////////////////////////////////////////////////////////////
                Center(
                  child: Container(
                    height: 300.00,
                    width: 700.00,
                    padding: EdgeInsets.only(top: 100),
                    child: Column(
                      children: [
                        ElevatedButton(
                          // all of these check if entryMadeToday is false. If false, run the ? if true run the :
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(100, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          onPressed: entryMadeToday ? null : beginEntry,
                          child: Icon(
                            entryMadeToday ? Icons.mic_off : Icons.mic,
                          ),
                        ),
                        Container(
                          height: 10.00,
                          padding: EdgeInsets.only(top: 100),
                        ),
                        Text(
                          entryMadeToday
                              ? "Entry already made today"
                              : "Begin your entry for today",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ///////////////////////////// THIRD PAGE ///////////////////////////////////////////////////////////////
                /// just a bunch of widgets for each of our faces
                Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Your monthly rating insights: "),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Image.asset(
                              'assets/images/Red Smiley.png',
                              scale: 2,
                            ),
                            Text(insightRatingList[0].toString())
                          ],
                        )),
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/Red Orange Smiley.png',
                                scale: 2,
                              ),
                              Text(insightRatingList[1].toString())
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/Orange Smiley.png',
                                scale: 2,
                              ),
                              Text(insightRatingList[2].toString())
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/Yellow Green Smiley.png',
                                scale: 2,
                              ),
                              Text(insightRatingList[3].toString())
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/Green Smiley.png',
                                scale: 2,
                              ),
                              Text(insightRatingList[4].toString())
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )),
              ],
              //       backgroundImage: NetworkImage(user.photoUrl!),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  beginEntry() async {
    if (!entryMadeToday) {
      // get the shared preferences instance
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.setBool('information', false);

      // get the information bool
      bool? informationStatus = prefs.getBool('information');
      informationStatus ??= false;

      // if they hadn't checked the box to get rid of the information page, send them to that TODO
      if (informationStatus == false) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InformationScreen(
            entryDao: entryDao,
          ),
        ));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FirstPrompt(entryDao: entryDao),
        ));
      }
    }
  }
}
