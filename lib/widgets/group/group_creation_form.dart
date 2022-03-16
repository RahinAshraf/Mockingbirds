import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veloplan/helpers/database_manager.dart';

class CreateGroupForm extends StatefulWidget {
  const CreateGroupForm(this.submitFn, this.isLoading, {Key? key})
      : super(key: key);

  final bool isLoading;
  final void Function(
    String ownerID,
    List<String> memberList,
    String code,
    String destination,
    BuildContext ctx,
  ) submitFn;

  @override
  _CreateGroupFormState createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<CreateGroupForm> {
  final DatabaseManager _dbManager = DatabaseManager();
  final _formKey = GlobalKey<FormState>();
  var _ownerID;
  var _destinaton = '';
  List<String> _list = [];

  @override
  void initState() {
    super.initState();
    _ownerID = _dbManager.getCurrentUser()?.uid;
  }

  void _trySubmit(String code) {
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
        _ownerID,
        _list,
        code,
        _destinaton,
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
                    child: const Text('Create new group'),
                    onPressed: () async {
                      Random rng = Random();
                      String codee = rng.nextInt(999999).toString();
                      var x = await _dbManager.getByEquality(
                          'group', 'code', codee);
                      while (x.size != 0) {
                        codee = rng.nextInt(999999).toString();
                        x = await _dbManager.getByEquality(
                            'group', 'code', codee);
                      }

                      print("this is the codeeeee0:   " + codee);
                      _trySubmit(codee);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}