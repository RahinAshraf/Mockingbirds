import 'package:flutter/material.dart';

import 'package:veloplan/styles/styling.dart';

class JourneyLandingPanelWidget extends StatefulWidget {
  @override
  _JourneyLandingPanelWidget createState() => _JourneyLandingPanelWidget();
}

class _JourneyLandingPanelWidget extends State<JourneyLandingPanelWidget> {
  @override
  Widget build(BuildContext context) =>
      Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Text(
          'Journey',
          style: infoTextStyle,
        ),
        Row(children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width / 2) - 24,
            child: const Text("Next stop:", style: tripSchedulerTextStyle),
          ),
          const SizedBox(width: 10),
        ])
      ]);
}
