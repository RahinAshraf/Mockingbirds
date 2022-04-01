import 'package:flutter/material.dart';
import '../../helpers/database_helpers/history_helper.dart';
import '../../models/itinerary.dart';
import '../../styles/colors.dart';
import '../../widgets/my_journey_card.dart';

/// Displays user's started (past) journeys.
/// Author: Tayyibah
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
          ? Center(child: Text("You haven't made any journeys yet."))
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: ListView.builder(
                itemCount: journeyList.length,
                itemBuilder: (context, index) {
                  return Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      height: MediaQuery.of(context).size.height * 0.23,
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
