import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:veloplan/helpers/database_manager.dart';
import 'package:veloplan/widgets/group/join_group_form.dart';

class GroupJoinScreen extends StatefulWidget {
  const GroupJoinScreen({Key? key}) : super(key: key);

  @override
  _GroupJoinScreenState createState() => _GroupJoinScreenState();
}

class _GroupJoinScreenState extends State<GroupJoinScreen> {
  final DatabaseManager _databaseManager = DatabaseManager();
  var _isLoading = false;
  late List groupCode = [];

  @override
  void initState() {
    super.initState();
  }

  void _submitGroupJoinForm(
    String ID,
    String code,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var id;
      var list;

      var temp = await _databaseManager.getByEquality('group', 'code', code);
      temp.docs.forEach((element) {
        id = element.id;
        list = element.data()['memberList'];
        list.add(_databaseManager.getCurrentUser()?.uid);
        _databaseManager.setByKey(
            'users',
            _databaseManager.getCurrentUser()!.uid,
            {'group': element.data()['code']},
            SetOptions(merge: true));
      });
      await _databaseManager.updateByKey('group', id, {'memberList': list});
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
      body: Column(
        children: [
          GroupJoinForm(
            _submitGroupJoinForm,
            _isLoading,
          ),
          FutureBuilder<List<String>>(builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(groupCode.toString());
            } else {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          })
        ],
      ),
    );
  }
}