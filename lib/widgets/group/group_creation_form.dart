import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../pickers/bottom_date_picker.dart';

class GroupCreationForm extends StatefulWidget {
  const GroupCreationForm(
      this.submitFn,
      this.isLoading,
      {Key? key}
      ) : super(key: key);

  final bool isLoading;
  final void Function(
      String ownerID,
      List<String> memberList,
      String code,
      String destination,
      BuildContext ctx,
      ) submitFn;

  @override
  _GroupCreationFormState createState() => _GroupCreationFormState();
}

class _GroupCreationFormState extends State<GroupCreationForm> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  var _ownerID;
  var _code = '';
  var _destinaton = '';
  List<String> _list =[];


  @override
  void initState(){
    super.initState();
    _ownerID =  auth.currentUser?.uid;
  }

  void _trySubmit(String codey) {
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
        codey,
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
                        var x = await FirebaseFirestore.instance
                            .collection('group')
                            .where('code',isEqualTo: codee)
                            .get();
                        while(x.size!=0){
                          codee=rng.nextInt(999999).toString();
                          x = await FirebaseFirestore.instance
                              .collection('group')
                              .where('code',isEqualTo: codee)
                              .get();
                        }

                        print("this is the codeeeee0:   " +codee);
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
