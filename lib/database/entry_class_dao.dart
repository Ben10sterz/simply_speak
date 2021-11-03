import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:simply_speak/database/entry_class.dart';
import 'entry_test.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EntryTestDao {
  final user = FirebaseAuth.instance.currentUser;
  List<dynamic> entryList = [];
  // Date, rating, title, 1st prompt, 2nd prompt, 3rd prompt

  DatabaseReference _entryRef = FirebaseDatabase.instance.reference();

  EntryTestDao() {
    _entryRef = _entryRef.child(user!.uid);
  }

  String getYearMonthDay() {
    DateTime date = new DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var compactDate = date.toString().split(' ')[0];
    return compactDate;
  }

  bool wasEntryMadeTodayAlready() {
    bool result = true;

    final test = _entryRef.get();

    print(test.toString());

    _entryRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        print("Hit here");
        result = true;
        //return;
      } else {
        Map<dynamic, dynamic> values = snapshot.value;

        for (var entries in values.values) {
          final message = Entry.fromJson(entries);

          print(message.date);

          var splitDate = message.date.split('-');
          // changes string to list of [year, month, day]

          print(DateTime.now().day);
          // print(splitDate[1])

          if (splitDate[0] == DateTime.now().year.toString()) {
            print("Year the same");
            if (splitDate[1] == DateTime.now().month.toString()) {
              print("Month is the same");
              if (splitDate[2] == DateTime.now().day.toString()) {
                print("yes they the same");
                result = false;
              } else if (splitDate[2] == '0' + DateTime.now().day.toString()) {
                print("okay NOW it is true");
                result = false;
              }
            }
          }

          //if(message.date == DateTime.now())
        }
      }

      //Map<dynamic, dynamic> deeper = values.values;

      //print(values.runtimeType.toString());

      //print(values.values.toString());

      //final json = snapshot.value as Map<dynamic, dynamic>;

      //final message = Entry.fromJson(json);

      // print(message);

      // List<dynamic> parsedListJson = jsonDecode(values.toString());

      // print(parsedListJson);

      // values.map((key, value) => list.add(value))

      // for (var prompts in values.values) {
      //   //List<dynamic> list = jsonDecode(prompts);
      //   //print(list.toString());
      //   //print("Key: " + prompts);
      //   print("Value: " + prompts.toString());
      //   //print('${values[prompts]}');
      // }

      //List<dynamic> list = jsonDecode(prompts);

      // values.forEach((key, value) async {
      //   if (value.toString().contains(getYearMonthDay())) {
      //     print("Should be false");
      //     result = !result;
      //     //print(result);
      //   }
      //   //  else {
      //   //   result = true;
      //   // }
      // });
    });

    return result;
    //return result;
  }

  void saveEntry() {
    Entry entry = Entry(getYearMonthDay(), entryList[1], entryList[2],
        entryList[3], entryList[4], entryList[5]);
    _entryRef.push().set(entry.toJson());
  }

  void checkForVal() {
    List<dynamic> entriesList = [];
    _entryRef.once().then((DataSnapshot snapshot) {
      // print('Data : ${snapshot.value}');
      // print(snapshot.key);
      // print(snapshot.value);
      Map<dynamic, dynamic> values = snapshot.value;
      //print(values);
      values.forEach((key, value) {
        entriesList.add(value.toString());
      });
      var i = 0;
      values.forEach((key, value) {
        print(i);
        print(value);
        i++;
        if (value.toString().contains(getYearMonthDay())) {
          print("Got it");
        }
      });
      // print(entriesList);
      // entriesList.forEach((element) {
      //   print(element.runtimeType);
      // });
      entriesList.forEach((element) {
        if (element.contains(getYearMonthDay())) {
          print(entriesList);
          print("yes contains");
        }
      });
    });
    print("test boy");
  }

  void resetEntryList() {
    entryList = [0, '', '', '', '', ''];
  }

  void setDate(DateTime date) {}

  void setPrompt(String prompt, var promptNum) {
    var promptLocation = promptNum + 2;
    //print(object);
    //print(entryList.length);
    entryList[promptLocation] = prompt;
    //print(entryList[promptLocation]);
  }

  void setTitle(String title) {
    entryList[2] = title;
  }

  void setRating(String rating) {
    entryList[1] = rating;
  }

  void printList() {
    for (var i = 0; i < entryList.length; i++) {
      print(entryList[i]);
    }
  }

  String getPrompt(var promptNum) => entryList[promptNum + 2];
  String getTitle() => entryList[2];
  String getRating() => entryList[1];
}
