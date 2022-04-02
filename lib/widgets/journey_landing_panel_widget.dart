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
          Column(
            children: [
              Text('Journey', style: infoTextStyle),
              const Divider(
                color: Colors.black,
                thickness: 3,
              ),
              ValueListenableBuilder(
                  valueListenable: widget.baseMapWithUpdatedRoute.dockName,
                  builder:
                      (BuildContext context, String dockName, Widget? child) {
                    return Text("Next stop: ${dockName}",
                        style: JourneyLandingTextStyle);
                  }),
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
                            style: JourneyLandingTextStyle)
                      ]);
                    }),
                SizedBox(height: 15),
                ValueListenableBuilder(
                    valueListenable: widget.baseMapWithUpdatedRoute.distance,
                    builder:
                        (BuildContext context, num distance, Widget? child) {
                      return Text("Distance: ${distance}m",
                          style: JourneyLandingTextStyle);
                    }),
              ])
            ],
          )
        ],
      );
}
