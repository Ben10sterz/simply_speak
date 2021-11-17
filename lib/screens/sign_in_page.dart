//import 'dart:js';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignInScreen extends StatefulWidget {
  // no use, just making flutter happy
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Simply Speak'),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              // Logo Container
              Container(
                height: 300.0,
                width: 250.0,
                padding: const EdgeInsets.only(top: 100),
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
              // Google sign in button using a user made widget SignInButton
              Container(
                height: 100.0,
                width: 250.0,
                padding: const EdgeInsets.only(top: 50),
                child: SignInButton(Buttons.Google, onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin();
                }),
              )
            ])));
  }
}
