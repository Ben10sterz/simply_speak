//import 'dart:js';
import 'package:flutter/material.dart';
import '../api/google_signin_api.dart';
import 'home_page.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Log-In'),
          centerTitle: true,
        ),
        body: Column(children: [
          Container(
            child: Center(
                child: TextButton(onPressed: signIn, child: Text('Login'))),
          ),
          Container(
            child: Center(
                child: TextButton(
                    onPressed: skipLogin, child: Text('Skip Login'))),
          ),
        ]));
  }

  Future signIn() async {
    final user = await GoogleSignInApi.login();

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign in failed')));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Homepage(),
      ));
    }
  }

  skipLogin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => Homepage(),
    ));
  }
}

// Future signIn() async {
//   final user = await GoogleSignInApi.login();

//   if (user == null) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign in failed')))
//   } else {

//   Navigator.of(context).pushReplacement(MaterialPageRoute(
//     builder: (context) => LoggedInPage(user: user),
//   ));}
// }
