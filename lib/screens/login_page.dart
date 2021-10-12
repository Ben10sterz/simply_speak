// ignore_for_file: prefer_const_constructors

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// import 'home_page.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool _isLoggedIn = false;
//   GoogleSignInAccount _userObj;
//   GoogleSignIn _googleSignIn = GoogleSignIn();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Simply Speak')),
//       body: Container(
//           child: _isLoggedIn
//               ? Column(
//                   children: [
//                     // Image.network(_userObj.photoUrl),
//                     // Text(_userObj.displayName),
//                     // Text(_userObj.email),
//                     // TextButton(
//                     //     onPressed: () {
//                     //       _googleSignIn.signOut().then((value) {
//                     //         setState(() {
//                     //           _isLoggedIn = false;
//                     //         });
//                     //       }).catchError((e) {});
//                     //     },
//                     //     child: Text("Logout"))
//                   ],
//                 )
//               : Center(
//                   child: ElevatedButton(
//                   child: Text("Login with Google"),
//                   onPressed: () {
//                     _googleSignIn.signIn().then((userData) {
//                       setState(() {
//                         print("madeithere");
//                         _isLoggedIn = true;
//                         _userObj = userData;
//                       })
//                       ;
//                     });
//                   if (_userObj != null) {
//                   Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                   builder: (context) => HomeScreen(
//                   user: _userObj,},
//                 ))),
//     );
//   }
// }
