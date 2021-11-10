// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simply_speak/database/entry_class.dart';
import 'package:simply_speak/database/entry_class_dao.dart';
import 'package:simply_speak/screens/first_prompt.dart';
import 'package:simply_speak/screens/information_page.dart';
import 'package:simply_speak/screens/specific_entry_review.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'sign_in_page.dart';
import '../api/google_sign_in_2.dart';
import 'calander_testing_page.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Homepage({
  //   Key? key,
  //   required this.user,
  // }) : super(key: key);

  @override
  initState() {
    facesList = [
      'assets/images/Red Smiley.png',
      'assets/images/Red Orange Smiley.png',
      'assets/images/Orange Smiley.png',
      'assets/images/Yellow Green Smiley.png',
      'assets/images/Green Smiley.png',
    ];

    _performEntryFetch(DateTime.now().month.toString());
  }

  List<String> facesList = [];
  List<String> ratingsList = [];
  List<String> calendarList = [];
  bool entryMadeToday = false;

  PageController pageController = PageController(initialPage: 1);
  int currentIndex = 1;

  final user = FirebaseAuth.instance.currentUser;

  final EntryTestDao entryDao = EntryTestDao();

  List<String> currentDateForCalendar = [
    DateTime.now().year.toString(),
    DateTime.now().month.toString()
  ];

  bool checkEntryMadeToday() {
    return entryDao.wasEntryMadeTodayAlready();
  }

  void _performEntryFetch(String month) {
    entryMadeToday = false;
    FirebaseDatabase.instance
        .reference()
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once()
        .then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      for (var entries in values.values) {
        final message = Entry.fromJson(entries);

        var splitDate = message.date.split('-');

        calendarList.add(message.date);
        ratingsList.add((int.parse(message.rating) - 1).toString());

        if (int.parse(splitDate[0]) == DateTime.now().year) {
          if (int.parse(splitDate[1]) == DateTime.now().month) {
            if (int.parse(splitDate[2]) == DateTime.now().day) {
              entryMadeToday = true;
            }
          }
        }
      }
      //final entries = Entry.fromJson(snapshot.value);
      //print(entries.date.toString());
    });
  }

  Future<bool> testFuture() async {
    await Future.delayed(const Duration(milliseconds: 500), () => "5");
    return Future<bool>.value(true);
  }

  // Stream<List> _initGetDatabase(List list) async {
  //   print("hit init GetDatabase");
  //   return calendarList = [
  //     'assets/images/Red Smiley.png',
  //     'assets/images/Red Orange Smiley.png'
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
    final database = FirebaseDatabase.instance.reference().child(user!.uid);

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
              icon: Icon(Icons.mic),
              label: "Record",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "Calendar",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Data",
            )
          ]),
      appBar: AppBar(
        title: Text('Simply Speak'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: <Widget>[
          CircleAvatar(backgroundImage: NetworkImage(user!.photoURL!)),
          TextButton(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //   builder: (context) => SignInScreen(),
                // ));
              },
              child: Text("Logout"))
          // IconButton(
          //     onPressed: () {
          //       print(user!.displayName);
          //     },
          //     icon: ImageIcon(NetworkImage(user!.photoURL!)))
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (page) {
          setState(() {
            currentIndex = page;
          });
        },
        children: [
          Center(
            child: Container(
              height: 500.00,
              width: 700.00,
              padding: EdgeInsets.only(top: 100),
              // color: Colors.white,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(100, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: beginEntry,
                    child: Icon(
                      entryMadeToday ? Icons.mic_off : Icons.mic,
                    ),
                  ),
                  Text(
                    entryMadeToday ? "Entry already made today" : "",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
          ),
          /////////////////////////////////////////////////////////////////////////////
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
                              titleCentered: true, formatButtonVisible: false),
                          rowHeight: 75.00,
                          daysOfWeekHeight: 20.00,
                          firstDay: DateTime(2021, 01, 01),
                          lastDay:
                              DateTime.now().add(const Duration(days: 5 * 365)),
                          focusedDay: DateTime.now(),
                          dayHitTestBehavior: HitTestBehavior.translucent,
                          onPageChanged: (date) {
                            // print(date.month.toString());
                            // _performEntryFetch(date.month.toString());
                            // Future.delayed(
                            //     const Duration(milliseconds: 500), () => "5");
                          },
                          calendarBuilders: CalendarBuilders(
                              defaultBuilder: (context, day, currentDay) {
                            var i = 0;
                            print(calendarList);
                            for (var item in calendarList) {
                              var splitDate = item.split('-');

                              // print("Wahat im looking for" +
                              //     facesList[int.parse(ratingsList[i])]);

                              // print(day.month);
                              // print(splitDate[2]);

                              if (day.year.toString() == splitDate[0]) {
                                if (day.month.toString() == splitDate[1]) {
                                  if (day.day == int.parse(splitDate[2])) {
                                    return Column(
                                      children: [
                                        IconButton(
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
                                        Text(day.day.toString())
                                      ],
                                    );
                                  }
                                }
                              }

                              i++;
                            }
                            return Column(
                              children: [Spacer(), Text(day.day.toString())],
                            );
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
          Container(
            color: Colors.cyan,
            child: Image(image: NetworkImage(user!.photoURL!)),
          ),
        ],
        //       backgroundImage: NetworkImage(user.photoUrl!),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () =>
      //       Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (context) => CalanderTest(),
      //   )),
      //   // pageController.animateToPage(0,
      //   //     duration: Duration(milliseconds: 250), curve: Curves.bounceIn),
      //   child: const Icon(Icons.mic),
      //   backgroundColor: Colors.cyan,
      // ),
    );
  }

  beginEntry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setBool('information', false);

    bool? informationStatus = prefs.getBool('information');

    informationStatus ??= false;

    if (informationStatus == false) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InformationScreen(
          entryDao: entryDao,
        ),
      ));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => FirstPrompt(entryDao: entryDao),
      ));
    }
  }

  void test() {
    print('Testing here');
  }
}
