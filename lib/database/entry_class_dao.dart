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
    DateTime now = DateTime.now();
    return (now.year.toString() +
        '/' +
        now.month.toString() +
        '/' +
        now.day.toString());
  }

  bool wasEntryMadeTodayAlready() {
    bool result = true;

    _entryRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        print("Hit here");
        result = true;
        //return;
      }

      Map<dynamic, dynamic> values = snapshot.value;

      values.forEach((key, value) {
        if (value.toString().contains(getYearMonthDay())) {
          print("Should be false");
          result = !result;
          print(result);
        }
        //  else {
        //   result = true;
        // }
      });
    });
    // ignore: avoid_print
    print(result);
    return result;
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
