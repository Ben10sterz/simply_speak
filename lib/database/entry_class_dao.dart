import 'package:firebase_database/firebase_database.dart';
import 'entry_test.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EntryTestDao {
  final user = FirebaseAuth.instance.currentUser;

  DatabaseReference _entryRef = FirebaseDatabase.instance.reference();

  EntryTestDao() {
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
}
