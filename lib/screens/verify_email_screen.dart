import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:veloplan/navbar.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isVerified) {
      sendVerification();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerification(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 60));
      await user.reload();
      if (!user.emailVerified && mounted) setState(() => canResendEmail = true);
    } catch (error) {
      var message = 'An error occurred, please try again later!';

      if (error.toString() != "") {
        message = error.toString();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      }
    }
  }

  Future checkEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return isVerified
        ? NavBar()
        : Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'assets/images/right_bubbles_shapes.png',
                      width: 170,
                      height: 170,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/security_icon.png',
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'A verification email has been sent to your address.',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                          ),
                          icon: const Icon(Icons.email, size: 32),
                          label: canResendEmail
                              ? const Text(
                                  'Resend Email',
                                  style: TextStyle(fontSize: 24),
                                )
                              : const Text(
                                  'Wait 1 minute to resend',
                                  style: TextStyle(fontSize: 24),
                                ),
                          onPressed:
                              canResendEmail ? () => sendVerification() : null,
                        ),
                        TextButton(
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 24),
                          ),
                          onPressed: () => FirebaseAuth.instance.signOut(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
