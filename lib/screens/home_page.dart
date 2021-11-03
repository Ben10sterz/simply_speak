// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Homepage({
  //   Key? key,
  //   required this.user,
  // }) : super(key: key);

  PageController pageController = PageController(initialPage: 1);
  int currentIndex = 1;

  final user = FirebaseAuth.instance.currentUser;

  final EntryTestDao entryDao = EntryTestDao();

  bool checkEntryMadeToday() {
    return entryDao.wasEntryMadeTodayAlready();
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
          Container(
            color: Colors.amber,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: beginEntry,
                  child: Icon(
                      // checkEntryMadeToday() ? Icons.mic :
                      Icons.mic_off),
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
                  dayHitTestBehavior: HitTestBehavior.translucent,
                  calendarBuilders:
                      CalendarBuilders(defaultBuilder: (context, day, test) {
                    final text = DateFormat.E().format(day);

                    return Center(
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                    //          }
                    //     dowBuilder: (context, day) {
                    //   if (day.weekday == DateTime.sunday) {
                    //     final text = DateFormat.E().format(day);

                    //     return Center(
                    //       child: Text(
                    //         text,
                    //         style: TextStyle(color: Colors.blue),
                    //       ),
                    //     );
                    //   }
                  }))),
          Container(
            color: Colors.cyan,
            child: Image(image: NetworkImage(user!.photoURL!)),
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
        onPressed: () => checkEntryMadeToday(),
        // pageController.animateToPage(0,
        //     duration: Duration(milliseconds: 250), curve: Curves.bounceIn),
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
