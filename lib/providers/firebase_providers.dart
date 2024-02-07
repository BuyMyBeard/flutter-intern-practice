import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final userProvider = StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());

// https://github.com/fireship-io/riverpod-firebase-demo/blob/main/lib/main.dart
// Join provider Streams
final dataProvider = StreamProvider<Map?>((ref) {
    final userStream = ref.watch(userProvider);
    var user = userStream.value; //.asData?.value;

    if (user != null) {
      var docRef = FirebaseFirestore.instance.collection('accounts').doc(user.uid);

      return docRef.snapshots().map((doc) => doc.data());
    }
    return const Stream.empty();
  },
);

final tasksDataProvider = StreamProvider<QuerySnapshot>((ref) {
    final userStream = ref.watch(userProvider);
    var user = userStream.value; //.asData?.value;

    if (user != null) {
      var query = FirebaseFirestore.instance.collection('Tasks').where("UID", isEqualTo: user.uid);
      return query.snapshots();
    }
    return const Stream.empty();
  },
);