// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simply_speak/database/entry_class.dart';
import 'package:simply_speak/database/entry_class_dao.dart';
import 'package:simply_speak/screens/first_prompt.dart';
import 'package:simply_speak/screens/information_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'sign_in_page.dart';
import '../api/google_sign_in_2.dart';

class CalanderTest extends StatefulWidget {
  @override
  _CalanderTestState createState() => _CalanderTestState();
}

class _CalanderTestState extends State<CalanderTest> {
  @override
  initState() {
    facesList = [
      'assets/images/Red Smiley.png',
      'assets/images/Red Orange Smiley.png',
      'assets/images/Orange Smiley.png',
      'assets/images/Yellow Green Smiley.png',
      'assets/images/Green Smiley.png',
    ];

    _performSingleMonthFetch(DateTime.now().month.toString());
  }

  List<String> facesList = [];
  List<String> ratingsList = [];
  List<String> calendarList = [];

  List<String> currentDateForCalendar = [
    DateTime.now().year.toString(),
    DateTime.now().month.toString()
  ];

  // void _performSingleFetch() {
  //   FirebaseDatabase.instance
  //       .reference()
  //       .child(FirebaseAuth.instance.currentUser!.uid)
  //       .once()
  //       .then((snapshot) {
  //     Map<dynamic, dynamic> values = snapshot.value;
  //     for (var entries in values.values) {
  //       //print(entries.toString());
  //       final message = Entry.fromJson(entries);
  //       calendarList.add(message.date);
  //       ratingsList.add((int.parse(message.rating) - 1).toString());

  //       //print(message.date);
  //     }
  //     //final entries = Entry.fromJson(snapshot.value);
  //     //print(entries.date.toString());
  //   });
  // }

  void _performSingleMonthFetch(String month) {
    FirebaseDatabase.instance
        .reference()
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once()
        .then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      for (var entries in values.values) {
        final message = Entry.fromJson(entries);
        var splitDate = message.date.split('-');

        if (splitDate[1] == month) {
          calendarList.add(message.date);
          ratingsList.add((int.parse(message.rating) - 1).toString());
        }
        //print(message.date);
      }
      //final entries = Entry.fromJson(snapshot.value);
      //print(entries.date.toString());
    });
  }

  Future<bool> testFuture() async {
    if (calendarList == []) {
      return Future<bool>.value(false);
    } else {
      return Future<bool>.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: testFuture(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return Center(
                  heightFactor: 300.0,
                  child: TableCalendar(
                      rowHeight: 75.00,
                      daysOfWeekHeight: 20.00,
                      firstDay: DateTime(2021, 11, 1),
                      lastDay:
                          DateTime.now().add(const Duration(days: 5 * 365)),
                      focusedDay: DateTime.now(),
                      dayHitTestBehavior: HitTestBehavior.translucent,
                      onDaySelected: (date, event) {
                        print(calendarList);
                        //print(date.toString());
                      },
                      onPageChanged: (date) {
                        print(date.month.toString());
                        _performSingleMonthFetch(date.month.toString());
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
                                      icon: Image.asset(
                                          facesList[int.parse(ratingsList[i])]),
                                      onPressed: () {
                                        print("Day 1: " + day.day.toString());
                                        //print(calendarList[day.day]);
                                        print("hit me");
                                      },
                                    ),
                                    Text(day.day.toString())
                                  ],
                                );
                              }
                            }
                          }

                          i++;
                        }
                      })));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        // pageController.animateToPage(0,
        //     duration: Duration(milliseconds: 250), curve: Curves.bounceIn),
        child: const Icon(Icons.mic),
        backgroundColor: Colors.cyan,
      ),
    );
  }
}
