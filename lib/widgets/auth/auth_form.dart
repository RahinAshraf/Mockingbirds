import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:veloplan/styles/styling.dart';
import 'package:veloplan/widgets/pickers/bottom_date_picker.dart';
import 'package:veloplan/widgets/pickers/image_picker.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading, {Key? key}) : super(key: key);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    String firstName,
    String lastName,
    File? image,
    DateTime dateTime,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _firstName = '';
  var _lastName = '';

  File? _userImageFile;
  var _confirmPassword = '';
  final TextEditingController _dateController = TextEditingController();
  DateTime _dateTime = DateTime.now();

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    // if (_userImageFile == null && !_isLogin) {
    //   Scaffold.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Please pick an image.'),
    //       backgroundColor: Theme.of(context).errorColor,
    //     ),
    //   );
    //   return;
    // }

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _firstName,
        _lastName,
        _userImageFile,
        _dateTime,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isLogin)
                  Image.asset(
                    'assets/images/logo_1.png',
                    height: 150.0,
                    width: 150.0,
                  ),
                if (_isLogin)
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Welcome back!',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 25),
                    ),
                  ),
                if (!_isLogin) const SizedBox(height: 50),
                if (!_isLogin) UserImagePicker(_pickedImage),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('firstName'),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 2) {
                        return 'Please enter at least 2 characters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'First Name'),
                    onSaved: (value) {
                      _firstName = value!;
                    },
                  ),
                const SizedBox(height: 15),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('lastName'),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 2) {
                        return 'Please enter at least 2 characters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    onSaved: (value) {
                      _lastName = value!;
                    },
                  ),
                const SizedBox(height: 15),
                TextFormField(
                  key: const ValueKey('email'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  validator: (value) => EmailValidator.validate(value!)
                      ? null
                      : "Please enter a valid email",
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                ),
                const SizedBox(height: 15),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('username'),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Username'),
                    onSaved: (value) {
                      _userName = value!;
                    },
                  ),
                const SizedBox(height: 15),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field can not be empty';
                    }
                    _confirmPassword = value;
                    if (value.length < 7) {
                      return 'Password must be at least 7 characters long.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (value) {
                    _userPassword = value!;
                  },
                ),
                const SizedBox(height: 15),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('passwordConfirmation'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field can not be empty';
                      }
                      if (value != _confirmPassword) {
                        return 'The passwords did not match';
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                  ),
                const SizedBox(height: 15),
                if (!_isLogin)
                  TextFormField(
                    controller: _dateController,
                    key: const ValueKey('date'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field can not be empty';
                      }
                      DateTime _eligibleDate = DateTime(
                        _dateTime.year + 16,
                        _dateTime.month,
                        _dateTime.day,
                      );
                      if (_eligibleDate.isAfter(DateTime.now())) {
                        return 'The minimum age for creating an account is 16';
                      }
                      return null;
                    },
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      //_selectDate();
                      showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return BottomDatePicker(
                            CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: _dateTime,
                              maximumDate: DateTime.now(),
                              onDateTimeChanged: (DateTime newDateTime) {
                                if (mounted) {
                                  setState(() {
                                    _dateTime = newDateTime;
                                    _dateController.text =
                                        DateFormat('dd-MM-yyyy')
                                            .format(_dateTime);
                                  });
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                    decoration:
                        const InputDecoration(labelText: 'Date of Birth'),
                  ),
                const SizedBox(height: 12),
                if (widget.isLoading) const CircularProgressIndicator(),
                if (!widget.isLoading)
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: ElevatedButton(
                      child: Text(_isLogin ? 'Log In' : 'Sign Up'),
                      onPressed: _trySubmit,
                    ),
                  ),
                if (!widget.isLoading)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin
                            ? 'Don\'t have an account?'
                            : 'Already have an account?',
                        style: authTextStyle,
                      ),
                      TextButton(
                        child: Text(_isLogin ? 'Sign up' : 'Log in'),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
