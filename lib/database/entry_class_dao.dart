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

  void saveEntry() {
    Entry entry = Entry(DateTime.now(), entryList[1], entryList[2],
        entryList[3], entryList[4], entryList[5]);
    _entryRef.push().set(entry.toJson());
  }

  void checkForVal() {
    _entryRef.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
      print(snapshot.key);
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
