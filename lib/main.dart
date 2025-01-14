import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/globals.dart';
import 'package:task_manager/widgets/main_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/New_York'));
  await initializeDateFormatting('fr_CA', null);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);
  // holy shit that is a mouthful verbose atrocity
  const InitializationSettings initSettings = InitializationSettings(
    android: AndroidInitializationSettings('app_icon')
  );
  
  await localNotifications.initialize(initSettings);
  
  runApp(const ProviderScope(child: MainApp()));
}