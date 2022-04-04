import 'package:flutter/material.dart';
import '../../models/itinerary.dart';
import '../../screens/splash_screen.dart';
import '../../helpers/database_helpers/database_manager.dart';
import '../../helpers/database_helpers/history_helper.dart';
import '../../widgets/my_journey_card.dart';
import '../../styles/styling.dart';

///Displays users started journeys
///Author: Tayyibah Uddin

class MyJourneys extends StatefulWidget {
  @override
  _MyJourneysState createState() => _MyJourneysState();
}

class _MyJourneysState extends State<MyJourneys> {
  late List<Itinerary> _journeyList;

  var _helper = HistoryHelper(DatabaseManager());

  @override
  void initState() {
    super.initState();
  }

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
            return SplashScreen(); //replace with our splash screen
          }
          return _journeyList.isEmpty
              ? SafeArea(
                  child: Center(
                      key: Key("noJourneys"),
                      child: Column(children: [
                        SizedBox(height: 100),
                        Image.asset('assets/images/past_journeys_sidebar.png',
                            width: 170, height: 170),
                        SizedBox(height: 40),
                        Text(
                          "You haven't made any journeys yet.",
                          style: sidebarTextStyle,
                        )
                      ])))
              : Stack(
                  children: [
                    ListView.builder(
                      key: Key("allJourneys"),
                      itemCount: _journeyList.length,
                      itemBuilder: (context, index) {
                        return MyJourneyCard(_journeyList[index]);
                      },
                    ),
                  ],
                );
        },
      ),
      appBar: AppBar(
        leading: BackButton(key: Key("back"), color: Colors.white),
        title: const Text('My Journeys'),
      ),
    );
  }
}
