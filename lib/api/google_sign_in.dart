import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  // initialize that we're gonna sign in with google
  final googleSignIn = GoogleSignIn();

  bool? _isSigningIn;
  bool? _isLoggedIn;

  // set these to false for starting to sign in
  GoogleSignInProvider() {
    _isSigningIn = false;
    _isLoggedIn = false;
  }

  bool get isSigningIn => _isSigningIn!;
  bool get isLoggedIn => _isLoggedIn!;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    // THIS is what is notifying our ChangeProvider for if we change whether we're logged in or not
    notifyListeners();
  }

  set isLoggedIn(bool isLoggedIn) {
    _isLoggedIn = isLoggedIn;
    // same here again as above
    notifyListeners();
  }

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  // function for trying to sign the user into Google
  Future googleLogin() async {
    // user is tryig to sign in
    isSigningIn = true;

    // the thing that pops up on the users screen asking them to sign in
    final googleUser = await googleSignIn.signIn();

    // if after exiting the screen above, they don't sign in then just return false
    if (googleUser == null) {
      isSigningIn = false;
      return;
    } else {
      // authenticate that this is the right Google user
      final googleAuth = await googleUser.authentication;

      // get their credentials for logging authenticating with Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // sign into Firebase using these credentials
      await FirebaseAuth.instance.signInWithCredential(credential);

      isSigningIn = false;
      isLoggedIn = true;
    }
  }

  void logout() async {
    // log out of Google AND Firebase
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    isLoggedIn = false;
  }
}
