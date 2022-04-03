import 'package:flutter/material.dart';
import 'package:veloplan/screens/splash_screen.dart';
import '../../helpers/database_helpers/database_manager.dart';
import '../../models/itinerary.dart';
import '../../helpers/database_helpers/history_helper.dart';
import '../../widgets/my_journey_card.dart';

///Displays users started journeys (history)
///Author: Tayyibah

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
              ? const SafeArea(
                  child:
                      Center(child: Text("You haven't made any journeys yet.")),
                )
              : Stack(
                  children: [
                    ListView.builder(
                      itemCount: _journeyList.length,
                      itemBuilder: (context, index) {
                        return MyJourneyCard(_journeyList[index]);
                      },
                    ),
                  ],
                );
        },
      ),

      //  journeyList.isEmpty
      //     ? const SafeArea(
      //         child: Center(child: Text("You haven't made any journeys yet.")),
      //       )
      //     : Stack(
      //         children: [
      //           ListView.builder(
      //             itemCount: journeyList.length,
      //             itemBuilder: (context, index) {
      //               return MyJourneyCard(journeyList[index]);
      //             },
      //           ),
      //         ],
      //       ),
      appBar: AppBar(
        title: const Text('My Journeys'),
      ),
    );
  }
}
