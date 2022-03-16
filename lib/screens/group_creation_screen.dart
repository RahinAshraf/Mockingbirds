import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:veloplan/widgets/group/group_creation_form.dart';

class GroupCreationScreen extends StatefulWidget {
  const GroupCreationScreen({Key? key}) : super(key: key);

  @override
  _GroupCreationScreenState createState() => _GroupCreationScreenState();
}

class _GroupCreationScreenState extends State<GroupCreationScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  late String code;

  @override
  void initState() {
    super.initState();
  }

  void _submitGroupCreationForm(
    String ownerID,
    List<String> memberList,
    code,
    String destination,
    BuildContext ctx,
  ) async {
    var ownerID = _auth.currentUser?.uid;
    List list = [];
    list.add(_auth.currentUser?.uid);

    try {
      setState(() {
        _isLoading = true;
      });
      await FirebaseFirestore.instance.collection('group').add({
        'code': code,
        'destination': destination,
        'ownerID': ownerID,
        'memberList': list,
        'createdAt': Timestamp.fromDate(DateTime.now())
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .set({'group': code}, SetOptions(merge: true));
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.message!),
          backgroundColor: Theme.of(context).errorColor,
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
      body: CreateGroupForm(
        _submitGroupCreationForm,
        _isLoading,
      ),
    );
  }
}