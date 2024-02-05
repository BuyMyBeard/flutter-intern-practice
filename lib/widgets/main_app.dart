import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider; 
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/providers/auth_providers.dart';
import 'package:task_manager/widgets/home.dart';


class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return MaterialApp(
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
      routes: {
        '/sign-in': (context) => SignInScreen(
          providers: ref.watch(authProviders), 
          actions: [
            AuthStateChangeAction<SignedIn>((context, state) { 
              Navigator.pushReplacementNamed(context, '/home');
            }),
          ]
        ),
        '/home': (context) => const Home(),
      }
    );
  }
}