import 'package:flutter/material.dart';
import '../helpers/history_helper.dart';
import '../styles/styling.dart';
import '../models/docking_station.dart';
import '../models/itinerary.dart';
import '../widgets/my_journey_card.dart';

///Loads users favourited docking stations and displays them in a list view.
///@author Tayyibah Uddin

//Loads cards of all of the users favourited docking station
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
        title: const Text('My Journeys'),
      ),
    );
  }
}
