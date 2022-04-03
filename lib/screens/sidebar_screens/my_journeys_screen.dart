import 'package:flutter/material.dart';
import 'package:veloplan/models/itinerary.dart';
import 'package:veloplan/helpers/database_helpers/history_helper.dart';
import 'package:veloplan/widgets/my_journey_card.dart';
import 'package:veloplan/styles/styling.dart';

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
          ? SafeArea(
              child: Center(
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
                  itemCount: journeyList.length,
                  itemBuilder: (context, index) {
                    return MyJourneyCard(journeyList[index]);
                  },
                ),
              ],
            ),
      appBar: AppBar(
        title: const Text('My Journeys'),
      ),
    );
  }
}
