import 'package:firebase_database/firebase_database.dart';
import 'package:simply_speak/database/entry_class.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EntryDao {
  final user = FirebaseAuth.instance.currentUser;
  // Date, rating, title, 1st prompt, 2nd prompt, 3rd prompt |
  //this is how entryList is laid out
  List<dynamic> entryList = [];

  // get a reference to the database
  DatabaseReference _entryRef = FirebaseDatabase.instance.reference();

  EntryDao() {
    // but the actual reference is to the current users Google ID
    _entryRef = _entryRef.child(user!.uid);
  }

  // get the current year, month day in the format that I am storing it in
  String getYearMonthDay() {
    DateTime date =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var compactDate = date.toString().split(' ')[0];
    return compactDate;
  }

  // save entry by sending it to the database as an Entry object
  void saveEntry() {
    Entry entry = Entry(getYearMonthDay(), entryList[1], entryList[2],
        entryList[3], entryList[4], entryList[5]);
    _entryRef.push().set(entry.toJson());
  }

  // just reset our current entry list
  void resetEntryList() {
    entryList = [0, '', '', '', '', ''];
  }

  ////////////////////// Functions below are used by other widgets to set our entry array
  void setPrompt(String prompt, var promptNum) {
    var promptLocation = promptNum + 2;
    entryList[promptLocation] = prompt;
  }

  void setTitle(String title) {
    entryList[2] = title;
  }

  void setRating(String rating) {
    entryList[1] = rating;
  }

  //////////////////////// These are used in our entry review to display all our entry contents
  String getPrompt(var promptNum) => entryList[promptNum + 2];
  String getTitle() => entryList[2];
  String getRating() => entryList[1];
}
