import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simply_speak/screens/home_page.dart';
import 'package:simply_speak/screens/sign_in_page.dart';
import '../api/google_sign_in.dart';
import 'package:provider/provider.dart';

class GoogleListener extends StatelessWidget {
  // no use, just to make flutter happy
  const GoogleListener({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          // Streambuilder will build/return new instances based on the snapshot which is obtained from stream:
          child: StreamBuilder(
            // listening on whether the users instance of Firebase Authentication has changed
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<GoogleSignInProvider>(context);

              // if they're signing in return a loading symbol
              if (provider.isSigningIn) {
                return buildLoading();
                // if they are signed in, retunr the homepage
              } else if (snapshot.hasData) {
                return const Homepage();
                // if they are not signed in and not currently trying to sign in, return the sign in screen
              } else {
                return const SignInScreen();
              }
            },
          ),
        ),
      );

  // this is returned when the user is currently signing in to Google
  Widget buildLoading() => Stack(
        fit: StackFit.expand,
        children: const [
          Center(child: CircularProgressIndicator()),
        ],
      );
}
