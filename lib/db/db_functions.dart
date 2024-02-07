 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/providers/firebase_providers.dart';
import 'package:logger/logger.dart';

getTasks(WidgetRef ref) {
  var db = FirebaseFirestore.instance;
  User? user = ref.read(userProvider).value;
  final tasksRef = db.collection("Tasks");
  final query = tasksRef.where("UID", isEqualTo: user!.uid);

  query.get().then((querySnapshot) {
    Logger().i("Successfully completed");
    Logger().i(querySnapshot.size);

    for (var docSnapshot in querySnapshot.docs) {
      Logger().i('${docSnapshot.id} => ${docSnapshot.data()}');
    }
  },
  onError: (e) => Logger().e("Error completing: $e"),
  );
}