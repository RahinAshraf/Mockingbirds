import 'package:flutter/material.dart';
import 'package:veloplan/styles/styling.dart';

class JourneyLandingPanelWidget extends StatefulWidget {
  late final num duration;
  late final num distance;
  late final String dockName;

  JourneyLandingPanelWidget(
      {required this.duration, required this.distance, required this.dockName});

  @override
  _JourneyLandingPanelWidget createState() => _JourneyLandingPanelWidget();
}

class _JourneyLandingPanelWidget extends State<JourneyLandingPanelWidget> {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Journey', style: infoTextStyle),
          Text("Next stop: ${widget.dockName}", style: tripSchedulerTextStyle),
          Text("Time: ${widget.duration}", style: tripSchedulerTextStyle),
          Text("Distance: ${widget.distance}", style: tripSchedulerTextStyle),
        ],
      );
}
