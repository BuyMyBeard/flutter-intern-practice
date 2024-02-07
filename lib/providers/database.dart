import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/providers/task.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Stream<QuerySnapshot> tasks(User user) {
    return _firestore.collection('Tasks').where("UID", isEqualTo: user.uid).snapshots();
  }

  Future<bool> addTask(Task task, User user) async {
    CollectionReference collectionRef = _firestore.collection('Tasks'); // referencing the movie collection .
    try {
      await collectionRef.add(task.toFirestore(user)); // Adding a new document to our movies collection
      return true; // finally return true 
    } catch (e) {
      return Future.error(e); // return error 
    }
  }
}

final databaseProvider = Provider((ref) => Database());