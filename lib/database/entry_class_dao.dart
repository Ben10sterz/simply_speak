import 'package:firebase_database/firebase_database.dart';
import 'entry_test.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EntryTestDao {
  final user = FirebaseAuth.instance.currentUser;
  List<dynamic> entryList = [];
  // Date, rating, title, 1st prompt, 2nd prompt, 3rd prompt

  DatabaseReference _entryRef = FirebaseDatabase.instance.reference();

  EntryTestDao() {
    print("test to see if it hit here");
    _entryRef = _entryRef.child(user!.uid);
  }

  void saveEntry(EntryTest entry) {
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
    //print(object);
    print(entryList.length);
    // plus 1 because that's where it appears in the list
    var promptLocation = promptNum + 1;
    entryList[promptLocation] = prompt;
    print(entryList[promptLocation]);
  }
}
