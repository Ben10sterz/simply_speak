import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_speak/screens/first_prompt.dart';

class InformationScreen extends StatefulWidget {
  InformationScreen({Key? key}) : super(key: key);
  @override
  _InformationScreenState createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Simply Speak'),
          centerTitle: true,
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(children: [
            Text(
                "Check this box if you no longer want to see the information screen"),
            Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    checkedBox(value);
                    isChecked = !isChecked;
                  });
                }),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EntryProcessScreen()));
                },
                child: Text("Go to entry process")),
          ]),
        ));
  }

  checkedBox(bool? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('information', value ?? false);
  }
}
