import 'package:flutter/material.dart';
import 'package:veloplan/models/map_models/base_map_with_route_updated_model.dart';
import 'package:veloplan/styles/styling.dart';

// Useful widget for displaying information about next docking station, distance and time in polyline_turn_by_turn_screen.

// Author: Hristina Andreea Sararu
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text('Journey', style: journeyTextStyle),
              const Divider(
                color: Colors.black,
                thickness: 3,
              ),
              ValueListenableBuilder(
                  valueListenable: widget.baseMapWithUpdatedRoute.dockName,
                  builder:
                      (BuildContext context, String dockName, Widget? child) {
                    return Text("Next stop: ${dockName}",
                        style: journeyLandingTextStyle);
                  }),
              SizedBox(
                height: 20,
              ),
              Row(children: [
                ValueListenableBuilder(
                    valueListenable: widget.baseMapWithUpdatedRoute.duration,
                    builder: (BuildContext context, num time, Widget? child) {
                      String t = (time.toDouble() / 60.0).toStringAsFixed(0);
                      return Row(children: [
                        Icon(
                          Icons.timelapse,
                        ),
                        Text("Time: ${t} minutes",
                            style: journeyLandingTextStyle),
                        VerticalDivider(
                          color: Colors.black,
                          thickness: 2,
                        )
                      ]);
                    }),
                ValueListenableBuilder(
                    valueListenable: widget.baseMapWithUpdatedRoute.distance,
                    builder:
                        (BuildContext context, num distance, Widget? child) {
                      return Expanded(
                          child: Row(children: [
                        widget.baseMapWithUpdatedRoute.currentStation == 0
                            ? Icon(
                                Icons.directions_walk,
                                size: 22,
                                color: Colors.black,
                              )
                            : ImageIcon(
                                AssetImage("assets/images/bicycle.png"),
                                color: Colors.black,
                                size: 22,
                              ),
                        Text(
                            distance >= 1000
                                ? "Distance: ${(distance / 1000).toStringAsFixed(2)}km"
                                : "Distance: ${distance.toStringAsFixed(0)}m",
                            style: journeyLandingTextStyle)
                      ]));
                    })
              ])
            ],
          )
        ],
      );
}
