import 'package:flutter/material.dart';
import '../../models/itinerary.dart';
import '../../helpers/database_helpers/history_helper.dart';
import '../../widgets/my_journey_card.dart';

///Displays users started journeys
///Author: Tayyibah

class MyJourneys extends StatefulWidget {
  @override
  _MyJourneysState createState() => _MyJourneysState();
}

class _MyJourneysState extends State<MyJourneys> {
  List<Itinerary> journeyList = [];

  var helper = HistoryHelper();

  @override
  void initState() {
    helper.getAllJourneyDocuments().then((data) {
      setState(() {
        journeyList = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: journeyList.isEmpty
          ? const SafeArea(
              child: Center(child: Text("You haven't made any journeys yet.")),
            )
          : Stack(
              children: [
                ListView.builder(
                  itemCount: journeyList.length,
                  itemBuilder: (context, index) {
                    return MyJourneyCard(journeyList[index]);
                  },
                ),
              ],
            ),
      appBar: AppBar(
        leading: BackButton(key: Key("back"), color: Colors.red),
        title: const Text('My Journeys'),
      ),
    );
  }
}
