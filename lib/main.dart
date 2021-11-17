import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simply_speak/api/google_sign_in.dart';
import 'package:simply_speak/screens/google_listener.dart';

import 'package:simply_speak/screens/sign_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // mamke sure that Firebase database is initialized
  await Firebase.initializeApp();
  // run below
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // no use, just need this to make flutter happy
  const MyApp({Key? key}) : super(key: key);

  @override // here our ChangeNotifierProvider is initialized for the next page checking to make sure the user is signed in
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          title: 'Simply Speak',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const GoogleListener(),
        ),
      );
}
