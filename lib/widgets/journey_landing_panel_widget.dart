import 'package:flutter/material.dart';
import 'package:veloplan/styles/styling.dart';

class JourneyLandingPanelWidget extends StatefulWidget {
  // late final num duration;
  // late final num distance;
  // late final String dockName;

  // JourneyLandingPanelWidget(
  //     {//required this.duration, required this.distance, required this.dockName
  //     });

  @override
  _JourneyLandingPanelWidget createState() => _JourneyLandingPanelWidget();
}

class _JourneyLandingPanelWidget extends State<JourneyLandingPanelWidget> {
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(26),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(
          children: [
            Text('Journey', style: infoTextStyle),
            const Divider(
              color: Color(0xFF99D2A9),
              thickness: 5,
            ),
            Row(children: [
              Text("Next stop: ", style: JourneyLandingTextStyle),
              SizedBox(
                width: 50,
              ),
              Text("Time:", style: JourneyLandingTextStyle)
            ]),
            Row(children: [
              Text("Stop 1", style: JourneyLandingTextStyle),
              SizedBox(
                width: 50,
              ),
              Text("Distance:", style: JourneyLandingTextStyle)
            ]),
          ],
        )
      ]));
}


//  Text("Next stop: ${widget.dockName}", style: tripSchedulerTextStyle),
//  Text("Time: ${widget.duration}", style: tripSchedulerTextStyle),
//  Text("Distance: ${widget.distance}", style: tripSchedulerTextStyle),