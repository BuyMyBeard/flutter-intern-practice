import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider, EmailAuthProvider; 
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProviders = Provider<List<AuthProvider<AuthListener, AuthCredential>>>((ref) {
  return [EmailAuthProvider()];
});