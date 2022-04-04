import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Screen  where the use can change their password.
/// Author(s): Eduard Ragea
class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _currentPassword = new TextEditingController();

  TextEditingController _newPassword = new TextEditingController();

  TextEditingController _confirmPassword = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool currentPasswordIsValid = true;

  /// Validate the form and check if the current password is valid.
  /// Update the password afterwards.
  void trySubmit(context) async {
    final isValid = _formKey.currentState!.validate();

    currentPasswordIsValid = await checkCurrentPassword(_currentPassword.text);

    setState(() {});

    FocusScope.of(context).unfocus();

    if (isValid && currentPasswordIsValid) {
      await updateUserPassword(_newPassword.text);

      Navigator.of(context).pop(true);
    }
  }

  /// Update the current user's password on Firebase
  Future updateUserPassword(String password) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    await currentUser!.updatePassword(password);
  }

  /// Check if the current password is valid by reauthenicating
  /// the user.
  /// Return false in case the reauthentication does not succeed.
  Future<bool> checkCurrentPassword(String password) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    final authCredential = EmailAuthProvider.credential(
        email: currentUser!.email!, password: password);

    try {
      final authResult =
          await currentUser.reauthenticateWithCredential(authCredential);

      return authResult.user != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool willLeave = false;
        // show the confirm dialog
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Are you sure want to leave?'),
                  content: Text("Any unsaved changes will be lost."),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          willLeave = true;
                          Navigator.of(context).pop();
                        },
                        child: const Text('Yes')),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('No'))
                  ],
                ));
        return willLeave;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.green,
          elevation: 0,
          title: const Text('Change Password'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  trySubmit(context);
                },
                child: const Icon(
                  Icons.check,
                  size: 26.0,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            physics: const BouncingScrollPhysics(),
            children: [
              TextFormField(
                key: const ValueKey('password'),
                controller: _currentPassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Current Password',
                  errorText: currentPasswordIsValid
                      ? null
                      : "Your password is incorrect",
                ),
                obscureText: true,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                key: const ValueKey('newPassword'),
                controller: _newPassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field can not be empty';
                  }
                  if (value.length < 7) {
                    return 'Password must be at least 7 characters long.';
                  }
                  String pattern =
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{7,}$';
                  RegExp regExp = new RegExp(pattern);
                  if (!regExp.hasMatch(value)) {
                    return 'Your password must have at least 1 Upper Case, 1 Lower Case and 1 Number.';
                  }
                  if (value == _currentPassword.text) {
                    return 'The new password cannot be your current password';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'New Password'),
                obscureText: true,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                key: const ValueKey('passwordConfirmation'),
                controller: _confirmPassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field can not be empty';
                  }
                  if (value != _newPassword.text) {
                    return 'The passwords did not match';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password'),
                obscureText: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
