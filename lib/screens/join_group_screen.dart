import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:veloplan/widgets/group/group_creation_form.dart';
import 'package:veloplan/widgets/group/join_group_form.dart';
import 'dart:math';

import '../widgets/auth/auth_form.dart';

class GroupJoinScreen extends StatefulWidget {
  const GroupJoinScreen({Key? key}) : super(key: key);

  @override
  _GroupJoinScreenState createState() => _GroupJoinScreenState();
}

class _GroupJoinScreenState extends State<GroupJoinScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;


  @override
  void initState() {
    super.initState();
  }

  void _submitGroupJoinForm(
      String ID,
      String code,
      BuildContext ctx,
      ) async {
    var ID = _auth.currentUser?.uid;

    try {
      setState(() {
        _isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('group')
          .where('code',isEqualTo: code)
          .get()
          .then(value){
        setState(){
          print(value);
        }
      }


      print("this is x : " + x..toString());
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';


      if (err.message != null) {
        message = err.message!;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme
              .of(ctx)
              .errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.message!),
          backgroundColor: Theme
              .of(context)
              .errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      // print(err);
      setState(() {
        _isLoading = false;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: GroupJoinForm(
        _submitGroupJoinForm,
        _isLoading,
      ),
    );
  }
}
