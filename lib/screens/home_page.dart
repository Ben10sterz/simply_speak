// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simply_speak/screens/entry_process.dart';
import 'package:simply_speak/screens/information_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sign_in_page.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //final GoogleSignInAccount user;

  // Homepage({
  //   Key? key,
  //   required this.user,
  // }) : super(key: key);

  PageController pageController = PageController(initialPage: 1);
  int currentIndex = 1;

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
        centerTitle: true,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (page) {
          setState(() {
            currentIndex = page;
          });
        },
        children: [
          Container(
            color: Colors.amber,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: beginEntry,
                  child: Icon(Icons.mic),
                )
              ],
            ),
          ),
          Container(
              color: Colors.blue,
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 5 * 365)),
                focusedDay: DateTime.now(),
              )),
          Container(
            color: Colors.cyan,
          ),
        ],

        // child: Column(
        //   children: [
        //     Text(
        //       'Profile',
        //       style: TextStyle(fontSize: 24),
        //     ),
        //     SizedBox(
        //       height: 32,
        //     ),
        //     CircleAvatar(
        //       radius: 40,
        //       backgroundImage: NetworkImage(user.photoUrl!),
        //     ),
        //     SizedBox(height: 8),
        //     Text('Name: ' + user.displayName!)
        //   ],
        // )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pageController.animateToPage(0,
            duration: Duration(milliseconds: 250), curve: Curves.bounceIn),
        child: const Icon(Icons.mic),
        backgroundColor: Colors.cyan,
      ),
    );
  }

  beginEntry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setBool('information', false);

    bool? informationStatus = prefs.getBool('information');

    informationStatus ??= false;

    if (informationStatus == false) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InformationScreen(),
      ));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EntryProcessScreen(),
      ));
    }
  }

  void test() {
    print('Testing here');
  }
}
