//import 'dart:js';
import 'package:flutter/material.dart';
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
          title: Text('Simply Speak'),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Container(
                height: 300.0,
                width: 250.0,
                padding: EdgeInsets.only(top: 100),
                decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(200),
                    //color: const Color(0xff7c94b6),
                    ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/Updated Simply Speak Logo.png',
                      scale: 1,
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
              ),
              Container(
                height: 100.0,
                width: 250.0,
                padding: EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(200),
                    //color: const Color(0xff7c94b6),
                    ),
                child: SignInButton(Buttons.Google, onPressed: () {
                  //waitingForSignin();
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin();
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //   builder: (context) => Homepage(),
                  // ));
                }),
              )
            ])));
  }

  // Future signIn() async {
  //   final user = await GoogleSignInApi.login();

  //   if (user == null) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Sign in failed')));
  //   } else {
  //     Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => Homepage(),
  //     ));
  //   }
  // }

  skipLogin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => Homepage(),
    ));
  }

  // waitingForSignin(bool needProvider) {
  //   final provider;
  //   if (needProvider) {
  //     final provider =
  //         Provider.of<GoogleSignInProvider>(context, listen: false);
  //     provider.googleLogin();
  //   }

  //   if (provider.isSigningIn) {
  //     waitingForSignin(false);
  //     return;
  //   } else if (provider.isLoggedIn) {
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       builder: (context) => Homepage(),
  //     ));
  //     providerProvided = false;
  //   } else {
  //     print("User did not sign in.");
  //     providerProvided = false;
  //   }
  // }
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
