import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/database_helpers/group_manager.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/screens/summary_journey_screen.dart';
import 'package:veloplan/utilities/dart_exts.dart';

class GroupId extends StatefulWidget {
  GroupId({Key? key}) : super(key: key);
  final DatabaseManager _databaseManager = DatabaseManager();

  @override
  State<StatefulWidget> createState() => GroupIdState(_databaseManager);
}

/// Renders a popup widget to join an existing journey with a 6-digit number.
///
/// A user is asked to input a 6-digit code, which is stored in [fullPin]
/// variable. If the code is correct, user 'joins' the group and is then
/// redirected to corresponding [SummaryJourneyScreen].
/// Authors: Lilianna, Marija
class GroupIdState extends State<GroupId> {
  late List<LatLng>? points;
  late final groupManager _groupManager;
  String fullPin = ''; // user's entered pin code
  bool successfulJoin = false;
  bool? exists = null;
  DatabaseManager _databaseManager;
  late Itinerary _itinerary;
  GroupIdState(this._databaseManager) {
    _groupManager = groupManager(_databaseManager);
  }

  @override
  void initState() {
    super.initState();
  }

  /// Adds user to an group, if the given [code] is correct and sets that group [exists].
  @visibleForTesting
  joinGroup(String code) async {
    var group = await _databaseManager.getByEquality('group', 'code', code);
    var list = [];
    String id = "";

    if (group.size == 0) {
      setState(() {
        exists = false;
      });
    } else {
      var user = await _databaseManager.getByKey(
          'users', _databaseManager.getCurrentUser()!.uid);
      if (user.data() != null) {
        var hasGroup = user.data()!.keys.contains('group');
        _itinerary = await _groupManager.joinGroup(code);
        context.push(SummaryJourneyScreen(_itinerary, false));
        setState(() {
          successfulJoin = hasGroup;
          exists = true;
        });
      }
    }
  }

  /// Returns an error message if the entered code is incorrect.
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
        child: Text("Enter PIN", textAlign: TextAlign.center),
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
                    }),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 0.5,
                  child: ElevatedButton(
                    onPressed: fullPin.length == 6
                        ? () async {
                            await joinGroup(fullPin);
                            if (exists != null &&
                                successfulJoin != null &&
                                exists! &&
                                successfulJoin) {
                              // context.push(
                              //     SummaryJourneyScreen(_itinerary, false));
                            }
                            if (!successfulJoin) {}
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
