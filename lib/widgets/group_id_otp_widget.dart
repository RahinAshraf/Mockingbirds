import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:veloplan/helpers/database_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/summary_journey_screen.dart';


//TODO : Redirect user if correct
//TODO : Empty field if incorrect
//TODO : Remove button

OtpFieldController otpController = OtpFieldController();

class GroupId extends StatefulWidget {
  const GroupId({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GroupIdState();
}

class GroupIdState extends State<GroupId> {
  final DatabaseManager _databaseManager = DatabaseManager();
  bool? exists = null;

  joinGroup(String code) async {
    print(" CODDD " + code);
    var group = await _databaseManager.getByEquality('group', 'code', code);

    var list = [];
    String id = "";

    if(group.size == 0){
      setState(() {
        exists = false;
      });
    }
    else{
      print(4);
      setState(() {
        exists = true;
      });
      group.docs.forEach((element) {
        print(element.data());
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
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0.0),
      titlePadding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0.0),
      title: const Center(
        child: Text(
          'Enter PIN',
          textAlign: TextAlign.center,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  OTPTextField(
                    controller: otpController,
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldWidth: 40,
                    fieldStyle: FieldStyle.box,
                    outlineBorderRadius: 10,
                    style: const TextStyle(fontSize: 17),
                    onChanged: (pin) {},
                    onCompleted: (pin) {
                      joinGroup(pin);
                      if(exists == null){

                      }
                      else if(exists!){
                        Navigator.pop(context,
                          MaterialPageRoute(
                              builder: (context) => SummaryJourneyScreen()),
                        );
                      }
                      else{
                        Navigator.pop(context);
                        showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (BuildContext context) => GroupId());
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 0.5,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Confirm'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}