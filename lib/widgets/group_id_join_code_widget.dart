import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/database_manager.dart';
import 'package:veloplan/helpers/navigation_helpers/navigation_conversion_helpers.dart';
import 'package:veloplan/screens/summary_journey_screen.dart';
import 'package:veloplan/utilities/dart_exts.dart';

class GroupId extends StatefulWidget {
  const GroupId({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => GroupIdState();
}

class GroupIdState extends State<GroupId> {
  String fullPin = "";
  late List<LatLng>? points;
  final DatabaseManager _databaseManager = DatabaseManager();
  bool? exists = null;

  @override
  void initState() {
    super.initState();
  }

  _joinGroup(String code) async {
    print(" CODE " + code);

    var group = await _databaseManager.getByEquality('group', 'code', code);
    var list = [];
    String id = "";

    if (group.size == 0) {
      setState(() {
        exists = false;
      });
    } else {
      setState(() {
        exists = true;
      });

      group.docs.forEach((element) {
        print(element.data());
        var geoList = element.data()['points'];
        List<List<double>> tempList = [];
        for (int i = 0; i < geoList.length; i++) {
          tempList.add([geoList[i].latitude, geoList[i].longitude]);
        }
        points = convertListDoubleToLatLng(tempList);
        print(points);
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
      context.push(SummaryJourneyScreen(points!));
    }
  }

  String? get _errorText {
    if (exists == false) {
      return "The entered code is incorrect.";
    }
    return null;
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
      title: const Center(
        child: Text(
          "Enter PIN",
          textAlign: TextAlign.center,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: 'PIN Code',
                    errorText: _errorText,
                  ),
                  onChanged: (pin) {
                    setState(() {
                      exists = null;
                      fullPin = pin;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 0.5,
                  child: ElevatedButton(
                    onPressed: fullPin.length == 6
                        ? () {
                            _joinGroup(fullPin);
                          }
                        : null,
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
