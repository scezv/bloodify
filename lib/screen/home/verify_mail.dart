import 'dart:async';

import 'package:bloodify/screen/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bloodify/screen/home/globals.dart';
//import 'package:projectfirst/Pages/HomePage.dart';

class VerifyMailPage extends StatefulWidget {
  const VerifyMailPage({Key? key}) : super(key: key);

  @override
  State<VerifyMailPage> createState() => _VerifyMailPageState();
}

class _VerifyMailPageState extends State<VerifyMailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      // Utils.showSncakBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? Home()
      : Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'A verification email has been sent to your email!!',
                    style: TextStyle(
                        fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Please, check your provided email',
                    style: TextStyle(
                        fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        sendVerificationEmail();
                        FirebaseAuth.instance.signOut();
                        final SnackBar snackBar = SnackBar(
                            content: Text("Verification e-mail sent!!!"));
                        snackbarKey.currentState?.showSnackBar(snackBar);
                      },
                      icon: const Icon(
                        Icons.email_rounded,
                        size: 32,
                      ),
                      label: const Text(
                        'Resend Email',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                      )),
                  TextButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color.fromARGB(255, 170, 57, 48),
                        ),
                      ))
                ],
              ),
            ),
          ),
        );
}
