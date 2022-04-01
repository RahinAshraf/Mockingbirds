import 'package:flutter/material.dart';
import 'package:veloplan/models/map_models/base_map_with_route_updated_model.dart';
import 'package:veloplan/styles/styling.dart';

class JourneyLandingPanelWidget extends StatefulWidget {
  MapWithRouteUpdated baseMapWithUpdatedRoute;

  JourneyLandingPanelWidget(this.baseMapWithUpdatedRoute, {Key? key})
      : super(key: key);

  @override
  _JourneyLandingPanelWidget createState() => _JourneyLandingPanelWidget();
}

class _JourneyLandingPanelWidget extends State<JourneyLandingPanelWidget> {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Journey', style: infoTextStyle),
          ValueListenableBuilder(
              valueListenable: widget.baseMapWithUpdatedRoute.dockName,
              builder: (BuildContext context, String dockName, Widget? child) {
                return Text("Next stop: ${dockName}",
                    style: tripSchedulerTextStyle);
              }),
          ValueListenableBuilder(
              valueListenable: widget.baseMapWithUpdatedRoute.duration,
              builder: (BuildContext context, num time, Widget? child) {
                String t = (time.toDouble()/60.0).toStringAsFixed(0);
                return Text("Time: ${t} minutes", style: tripSchedulerTextStyle);
              }),
          ValueListenableBuilder(
              valueListenable: widget.baseMapWithUpdatedRoute.distance,
              builder: (BuildContext context, num distance, Widget? child) {
                return Text("Distance: ${distance}m",
                    style: tripSchedulerTextStyle);
              }),
        ],
      );
}


//  Text("Next stop: ${widget.dockName}", style: tripSchedulerTextStyle),
//  Text("Time: ${widget.duration}", style: tripSchedulerTextStyle),
//  Text("Distance: ${widget.distance}", style: tripSchedulerTextStyle),