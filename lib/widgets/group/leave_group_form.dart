import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../pickers/bottom_date_picker.dart';

class LeaveGroupForm extends StatefulWidget {
  const LeaveGroupForm(
      this.submitFn,
      this.isLoading,
      {Key? key}
      ) : super(key: key);

  final bool isLoading;
  final void Function(
      String ID,
      BuildContext ctx,
      ) submitFn;

  @override
  _LeaveGroupFormState createState() => _LeaveGroupFormState();
}

class _LeaveGroupFormState extends State<LeaveGroupForm> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  var _ID;



  @override
  void initState(){
    super.initState();
    _ID =  auth.currentUser?.uid;
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
        _ID,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextButton(
                    child: const Text('leave group'),
                    onPressed: () {
                      _trySubmit();

                    },

                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
