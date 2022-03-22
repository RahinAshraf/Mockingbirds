import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class ForgotPasswordScreen extends StatelessWidget {
  TextEditingController emailController = new TextEditingController();

  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Column(
        children: [
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
              border: OutlineInputBorder(),
              labelText: 'Email Address',
            ),
          ),
          ElevatedButton(
                      child: Text('Send password reset email'),
                      onPressed: null,
                    ),
        ],
      ),
    );
  }
}
