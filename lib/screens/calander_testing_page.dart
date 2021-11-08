// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    calendarList = [
      'assets/images/Red Smiley.png',
      'assets/images/Red Orange Smiley.png'
    ];
  }

  List<String> calendarList = [];
  List<String> currentDateForCalendar = [
    DateTime.now().year.toString(),
    DateTime.now().month.toString()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TableCalendar(
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 5 * 365)),
          focusedDay: DateTime.now(),
          dayHitTestBehavior: HitTestBehavior.translucent,
          onDaySelected: (date, event) {
            print(date.toString());
          },
          onPageChanged: (date) {
            //_initGetDatabase(currentDateForCalendar);
            calendarList = [
              'assets/images/Red Smiley.png',
              'assets/images/Red Orange Smiley.png'
            ];
          },
          calendarBuilders:
              CalendarBuilders(defaultBuilder: (context, day, test) {
            final text = DateFormat.E().format(day);

            return Center(
              child: IconButton(
                icon: Image.asset(calendarList[1]),
                onPressed: () {
                  print("hit me");
                },
              ),
            );
          })),
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
