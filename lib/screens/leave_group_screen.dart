import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:veloplan/helpers/database_manager.dart';
import 'package:veloplan/widgets/group/leave_group_form.dart';

// TODO: remove group when empty
class GroupCreationScreen extends StatefulWidget {
  const GroupCreationScreen({Key? key}) : super(key: key);

  @override
  _GroupCreationScreenState createState() => _GroupCreationScreenState();
}

class _GroupCreationScreenState extends State<GroupCreationScreen> {
  final DatabaseManager _databaseManager = DatabaseManager();
  var _isLoading = false;
  late String code;

  @override
  void initState() {
    super.initState();
  }

  void _submitLeaveGroupForm(
    String ownerID,
    BuildContext ctx,
  ) async {
    var userID = _databaseManager.getCurrentUser()?.uid;
    try {
      setState(() {
        _isLoading = true;
      });
      List list = [];

      var user = await _databaseManager.getByKey('users', userID!);
      var code = user.data()!['group'];
      var id;

      var temp = await _databaseManager.getByEquality('group', 'code', code);
      temp.docs.forEach((element) {
        id = element.id;
        list = element.data()['memberList'];
        list.removeWhere((element) => element.id == userID);
        if (list.isEmpty) {
          element.reference.delete();
        } else {
          _databaseManager.updateByKey('group', id!, {'memberList': list});
        }
      });
      await _databaseManager.setByKey(
          'users', userID, {'group': null}, SetOptions(merge: true));
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
      body: LeaveGroupForm(
        _submitLeaveGroupForm,
        _isLoading,
      ),
    );
  }
}