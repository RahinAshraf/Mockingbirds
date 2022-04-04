import 'package:flutter/material.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';
import 'package:veloplan/helpers/database_helpers/history_helper.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/screens/splash_screen.dart';
import 'package:veloplan/styles/colors.dart';
import 'package:veloplan/styles/texts.dart';
import 'package:veloplan/widgets/my_journey_card.dart';

/// Displays user's started/past journeys.
/// Author: Tayyibah
class MyJourneys extends StatefulWidget {
  @override
  _MyJourneysState createState() => _MyJourneysState();
}

class _MyJourneysState extends State<MyJourneys> {
  late List<Itinerary> _journeyList;
  var _helper = HistoryHelper(DatabaseManager());

  Future<List<Itinerary>> setHistory() async {
    this._journeyList = await _helper.getAllJourneyDocuments();
    return _journeyList;
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: FutureBuilder<List<Itinerary>>(
        future: setHistory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SplashScreen();
          }
          return _journeyList.isEmpty
              ? Center(
                  key: Key("noJourneys"),
                  child: Column(children: [
                    SizedBox(height: 100),
                    Image.asset('assets/images/past_journeys_sidebar.png',
                        width: 170, height: 170),
                    SizedBox(height: 40),
                    Text(
                      "You haven't made any journeys yet.",
                      style: CustomTextStyles.sidebarTextStyle,
                    )
                  ]))
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: ListView.builder(
                    key: Key("allJourneys"),
                    itemCount: _journeyList.length,
                    itemBuilder: (context, index) {
                      return Container(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          height: MediaQuery.of(context).size.height * 0.30,
                          child: MyJourneyCard(_journeyList[index]));
                    },
                  ),
                );
        },
      ),
      appBar: AppBar(
        leading: BackButton(key: Key("back"), color: Colors.white),
        title: const Text('My Journeys'),
      ),
      backgroundColor: CustomColors.whiteReplacement,
    );
  }
}
