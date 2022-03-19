import 'package:flutter/material.dart';
import '/models/docking_station.dart';
import '../helpers/favourite_service.dart';

///Creates a card for a journey, to include its time
///Author: Tayyibah

class MyJourneyCard extends StatefulWidget {
  late final String journeyStartTime;

  MyJourneyCard(
    this.journeyStartTime,
  );

  @override
  _MyJourneyCardState createState() => _MyJourneyCardState();
}

class _MyJourneyCardState extends State<MyJourneyCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      shadowColor: Colors.green[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.journeyStartTime,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
