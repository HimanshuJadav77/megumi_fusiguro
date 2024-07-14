import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Services/mail_verification.dart';
import 'package:untitled/login.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyBHCivXkNaYhZV3yFlfh2vvLOFjVMgE_1M',
              appId: '1:820909909395:android:f10bdfbf26094098273466',
              messagingSenderId: '820909909395',
              projectId: 'untitled-7e434'))
      : await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapShot) {
            if (snapShot.hasData) {
              return verifyEmail();
            } else {
              return Login();
            }
          }),
    );
  }
}
