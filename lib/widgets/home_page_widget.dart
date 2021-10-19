// import 'dart:html';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../api/google_sign_in_2.dart';
// import 'package:provider/provider.dart';



// class HomePageWidget extends StatefulWidget {
//   PageController pageController = PageController(initialPage: 1);
//   int currentIndex = 1;

//   @override
//   Widget build (BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return PageView(
//         controller: pageController,
//         onPageChanged: (page) {
//           setState(() {
//             currentIndex = page;
//           });
//         },
//         children: [
//           Container(
//             color: Colors.amber,
//             child: Column(
//               children: [
//                 ElevatedButton(
//                   onPressed: () {},//beginEntry,
//                   child: Icon(Icons.mic),
//                 )
//               ],
//             ),
//           ),
//           Container(
//               color: Colors.blue,
//               child: TableCalendar(
//                 firstDay: DateTime.now(),
//                 lastDay: DateTime.now().add(const Duration(days: 5 * 365)),
//                 focusedDay: DateTime.now(),
//               )),
//           Container(
//             color: Colors.cyan,
//           ),
//         ],

//         // child: Column(
//         //   children: [
//         //     Text(
//         //       'Profile',
//         //       style: TextStyle(fontSize: 24),
//         //     ),
//         //     SizedBox(
//         //       height: 32,
//         //     ),
//         //     CircleAvatar(
//         //       radius: 40,
//         //       backgroundImage: NetworkImage(user.photoUrl!),
//         //     ),
//         //     SizedBox(height: 8),
//         //     Text('Name: ' + user.displayName!)
//         //   ],
//         // )),
//       )
//   }
// }






