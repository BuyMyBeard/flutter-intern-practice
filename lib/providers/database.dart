import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/providers/task.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User get user => FirebaseAuth.instance.currentUser!;  

  Stream<QuerySnapshot> tasks() {
    return _firestore.collection('Tasks').where("UID", isEqualTo: user.uid).snapshots();
  }

  Future<bool> addTask(Task task) async {
    CollectionReference collectionRef = _firestore.collection('Tasks');
    try {
      await collectionRef.add(task.toFirestore(user));
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> removeTask(Task task) async {
    CollectionReference collectionRef = _firestore.collection('Tasks');
    try {
      await collectionRef.doc(task.id).delete();
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> editTask(Task task) async {
    CollectionReference collectionRef = _firestore.collection('Tasks');
    try {
      await collectionRef.doc(task.id).set(task.toFirestore(user));
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }
}

final databaseProvider = Provider((ref) => Database());