import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mapbox_gl/mapbox_gl.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/services.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:veloplan/helpers/database_manager.dart';

import '../helpers/navigation_helpers/navigation_conversion_helpers.dart';
import 'navigation/map_with_route_screen.dart';

class SummaryJourneyScreen extends StatefulWidget {
  List<List<double?>?> points;
  SummaryJourneyScreen(this.points, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SummaryJourneyScreenState();
}

class SummaryJourneyScreenState extends State<SummaryJourneyScreen> {
  final DatabaseManager _databaseManager = DatabaseManager();
  bool isInGroup = false;
  late String groupID = "";
  late String organiser = "";
  late List<List<double?>?> points;

  @override
  void initState() {
    points = widget.points;
    _setData();

    super.initState();
  }

  Future<String> _getGroup() async {
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
    groupID = user.data()!['group'];
    return user.data()!['group'];
  }

  _setData() async {
    print('1');
    var res;
    var user = await _databaseManager.getByKey(
        'users', _databaseManager.getCurrentUser()!.uid);
    var hasGroup = user.data()!.keys.contains('group');
    if (hasGroup) {
      var group = await _databaseManager.getByEquality(
          'group', 'code', user.data()!['group']);
      res = await _getGroupOwner(group);
      group.docs.forEach((element) {
        points = convertStringToList(element.data()['points']);
      });
    }
    print(hasGroup);
    setState(() {
      isInGroup = hasGroup;
      organiser = user.data()!['username'];
      if (isInGroup) {

        organiser = res.data()!['username'];
      }
      print('ORG ' + organiser);
    });
  }


  Future<DocumentSnapshot<Map<String, dynamic>>> _getGroupOwner(
      QuerySnapshot<Map<String, dynamic>> group) {
    var tempr;
    group.docs.forEach((element) {
      tempr = _databaseManager.getByKey('users', element.data()['ownerID']);
    });
    return tempr;
  }

  void _createGroup() async {
    print("GDGGDG");
    var ownerID = _databaseManager.getCurrentUser()?.uid;
    List list = [];
    list.add(ownerID);
    String destination = "";
    Random rng = Random();
    String code = rng.nextInt(999999).toString();
    var x = await _databaseManager.getByEquality('group', 'code', code);
    while (x.size != 0) {
      code = rng.nextInt(999999).toString();
      x = await _databaseManager.getByEquality('group', 'code', code);
    }
    print('A');

    try {
      await _databaseManager.addToCollection('group', {
        'code': code,
        'destination': destination,
        'ownerID': ownerID,
        'memberList': list,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'points': points.join(),
      });
      await _databaseManager.setByKey(
          'users', ownerID!, {'group': code}, SetOptions(merge: true));

      setState(() {
        isInGroup = true;
      });
    } on PlatformException catch (err) {
      var message = 'An error occurred';

      if (err.message != null) {
        message = err.message!;
      }
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.message!),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (err) {
       print(err);
    }
  }

  _leaveGroup() async {
    try {
      var temp = await _databaseManager.getByEquality('group', 'code', groupID);
      var userID = _databaseManager.getCurrentUser()?.uid;
      for (var element in temp.docs) {
        List list = element.data()['memberList'];
        list.removeWhere((element) => (element == userID));
        if (list.isEmpty) {
          element.reference.delete();
        } else {
          _databaseManager
              .updateByKey('group', element.id, {'memberList': list});
        }
      }
      await _databaseManager
          .updateByKey('users', userID!, {'group': FieldValue.delete()});
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.message!),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (err) {
      //print(err);
    }
    setState(() {
      isInGroup = false;
      organiser = _databaseManager.getCurrentUser()!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                color: Theme.of(context).primaryColor,
                child: const Text(
                  'Summary of Journey',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 25),
                )),
            //const SizedBox(height: 30),
            Container(
                height: 120.0,
                width: 120.0,
                child: Center(
                    child: Image.asset('assets/images/summary_journey.png'))),
            //const SizedBox(height: 30),
            Container(
                height: 30,
                padding: const EdgeInsets.fromLTRB(75, 5, 75, 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10.0,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Text('Organiser:' + organiser,
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                )),
            if (isInGroup)
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  color: Theme.of(context).primaryColor,
                  child: FutureBuilder<String>(
                      future: _getGroup(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GestureDetector(
                            child: Text(
                              "Tap here to copy the code: " + groupID,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13),
                            ),
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: groupID),
                              );
                            },
                          );
                        } else {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height / 1.3,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      })),
            if (!isInGroup)
              Container(
                  height: 30,
                  padding: const EdgeInsets.fromLTRB(75, 5, 75, 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10.0,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                    ),
                    child: const Text('Share journey',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      print("PUSHD");
                      _createGroup();
                    },
                  )),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                      child: ImageIcon(
                        AssetImage("assets/images/logo.png"),
                        color: Color(0xFF99D2A9),
                        size: 24,
                      )),
                  TextSpan(
                      text: "Planned stops:",
                      style: TextStyle(color: Color(0xFF99D2A9), fontSize: 25)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TimelineTile(
              isFirst: true,
              beforeLineStyle: const LineStyle(
                thickness: 1.0,
                color: Color(0XFFe1e1e1),
              ),
              indicatorStyle: const IndicatorStyle(
                padding: EdgeInsets.all(5),
                width: 10,
                indicatorXY: 0.0,
                color: Color(0xFF99D2A9),
              ),
              alignment: TimelineAlign.start,
              endChild: Card(
                elevation: 1,
                margin: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Station 1',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Color(0xFF99D2A9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ImageIcon(
                        AssetImage("assets/images/logo.png"),
                        color: Color(0xFF99D2A9),
                        size: 24,
                      )
                    ],
                  ),
                ),
              ),
            ),
            TimelineTile(
              isFirst: true,
              beforeLineStyle: const LineStyle(
                thickness: 1.0,
                color: Color(0XFFe1e1e1),
              ),
              indicatorStyle: const IndicatorStyle(
                padding: EdgeInsets.all(5),
                width: 10,
                indicatorXY: 0.0,
                color: Color(0xFF99D2A9),
              ),
              alignment: TimelineAlign.start,
              endChild: Card(
                elevation: 1,
                margin: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Station 2',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Color(0xFF99D2A9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //SizedBox(width: 200.0),
                      ImageIcon(
                        AssetImage("assets/images/logo.png"),
                        color: Color(0xFF99D2A9),
                        size: 24,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Final stop:',
                  style: TextStyle(color: Color(0xFF99D2A9), fontSize: 18),
                )),
            const SizedBox(height: 20),
            if (isInGroup)
              Container(
                  height: 40,
                  padding: const EdgeInsets.fromLTRB(100, 5, 100, 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10.0,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                    ),
                    child: const Text('LEAVE GROUP',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _leaveGroup();
                    },
                  )),
            Container(
                padding: const EdgeInsets.fromLTRB(70, 5, 70, 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 10.0, shape: StadiumBorder()),
                  child: const Text('START JOURNEY',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  MapRoutePage(convertListDoubleToLatLng(points)!),
                    )
                    );
                  },
                )),
          ],
        ));
  }
}