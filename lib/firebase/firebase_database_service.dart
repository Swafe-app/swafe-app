import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  static final FirebaseDatabaseService _instance = FirebaseDatabaseService._internal();

  factory FirebaseDatabaseService() {
    return _instance;
  }

  FirebaseDatabaseService._internal();

  DatabaseReference get databaseReference => _databaseReference;
}
