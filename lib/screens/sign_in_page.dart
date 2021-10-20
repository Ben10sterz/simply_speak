//import 'dart:js';
import 'package:flutter/material.dart';
import '../api/google_signin_api.dart';
import 'home_page.dart';
import 'package:provider/provider.dart';
import '../api/google_sign_in_2.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

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
            height: 300.0,
            width: 250.0,
            padding: EdgeInsets.only(top: 100),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              //color: const Color(0xff7c94b6),
            ),
            child: Center(
              child: Image.asset('assets/images/SimplySpeakLogo.png'),
            ),
          ),
          Container(
            child: Center(
                child: TextButton(
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.googleLogin();
                    },
                    child: Text('Login'))),
          ),
          Container(
            child: Center(
                child: TextButton(
                    onPressed: skipLogin, child: Text('Skip Login'))),
          ),
          Container(
            padding: EdgeInsets.only(top: 100),
            child: SignInButton(Buttons.Google, onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
            }),
          )
        ]));
  }

  Future signIn() async {
    final user = await GoogleSignInApi.login();

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign in failed')));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
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
