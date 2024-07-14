import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/crud.dart';
import 'package:untitled/elevated.dart';
import 'package:untitled/login.dart';
import 'package:untitled/snackbar.dart';

class verifyEmail extends StatefulWidget {
  verifyEmail({super.key});

  @override
  State<verifyEmail> createState() => _verifyEmailState();
}

class _verifyEmailState extends State<verifyEmail> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 2), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const FirestoreDatabase()
      : Scaffold(
          appBar: AppBar(
            title: Text("Verifying  Email.."),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "A Verification Mail  Is Sent to Your Email.",
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              elevated(
                  onTab: () {
                    canResendEmail ? sendVerificationEmail : null;
                  },
                  text: "Resend Email"),
              elevated(
                  onTab: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  text: "Cancel")
            ],
          ),
        );
}
