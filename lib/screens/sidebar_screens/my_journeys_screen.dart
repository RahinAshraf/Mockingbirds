import 'package:flutter/material.dart';
import 'package:veloplan/helpers/database_helpers/history_helper.dart';
import 'package:veloplan/models/itinerary.dart';
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
  List<Itinerary> journeyList = [];
  HistoryHelper helper = HistoryHelper();

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
          ? Center(
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Image.asset('assets/images/past_journeys_sidebar.png',
                      width: 170, height: 170),
                  SizedBox(height: 40),
                  Text(
                    "You haven't made any journeys yet.",
                    style: sidebarTextStyle,
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: ListView.builder(
                itemCount: journeyList.length,
                itemBuilder: (context, index) {
                  return Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: MyJourneyCard(journeyList[index]));
                },
              ),
            ),
      appBar: AppBar(
        title: const Text('My Journeys'),
      ),
      backgroundColor: CustomColors.whiteReplacement,
    );
  }
}
