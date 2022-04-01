import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:veloplan/styles/styling.dart';

// Contains forgot password feature.
// Author: Eduard, Hristina

class ForgotPasswordScreen extends StatelessWidget {
  TextEditingController emailController = new TextEditingController();

  ForgotPasswordScreen({Key? key}) : super(key: key);

  Future sendPasswordResetEmail(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.of(context).pop(true);
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            err.message!,
          ),
        ),
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            err.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 35),
          Container(
              height: 170.0,
              width: 170.0,
              alignment: Alignment.topRight,
              child: Image.asset('assets/images/forgot_password_icon.png')),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Please enter your email address to  request a password reset:',
                      style: forgotPasswordTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      key: ValueKey('email'),
                      controller: emailController,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      validator: (value) => EmailValidator.validate(value!)
                          ? null
                          : "Please enter a valid email",
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: const BorderSide(
                              color: Color(0xFF99D2A9), width: 2.0),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Email Address',
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      child: Text('Send password reset email'),
                      onPressed: () =>
                          sendPasswordResetEmail(emailController.text, context),
                    ),
                  ])),
        ],
      ),
    );
  }
}
