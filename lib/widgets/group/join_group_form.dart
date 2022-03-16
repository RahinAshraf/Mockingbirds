import 'dart:io';

import 'package:flutter/material.dart';
import 'package:veloplan/helpers/database_manager.dart';

import '../pickers/bottom_date_picker.dart';

class GroupJoinForm extends StatefulWidget {
  const GroupJoinForm(this.submitFn, this.isLoading, {Key? key})
      : super(key: key);

  final bool isLoading;
  final void Function(
    String ID,
    String code,
    BuildContext ctx,
  ) submitFn;

  @override
  _GroupJoinFormState createState() => _GroupJoinFormState();
}

class _GroupJoinFormState extends State<GroupJoinForm> {
  final DatabaseManager _dbManager = DatabaseManager();
  final _formKey = GlobalKey<FormState>();
  var _ID;
  var _code = '';

  @override
  void initState() {
    super.initState();
    _ID = _dbManager.getCurrentUser()?.uid;
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
        _code,
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
                    child: const Text('join group'),
                    onPressed: () {
                      _trySubmit();
                      print(_code);
                    },
                  ),
                  TextFormField(
                    key: const ValueKey('code'),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Code'),
                    onSaved: (value) {
                      _code = value!;
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