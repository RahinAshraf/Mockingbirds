import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:veloplan/styles/colors.dart';
import 'package:veloplan/styles/styling.dart';
import 'package:veloplan/styles/texts.dart';

/// Generates an item in timeline. Used in [SummaryJourneyScreen].
/// Author: Marija
class TimelineItem extends StatelessWidget {
  const TimelineItem(
      {this.first = false,
      this.last = false,
      required this.content,
      required this.duration,
      required this.distance});

  final bool first;
  final bool last;
  final String content;
  final double distance;
  final double duration;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: first,
      isLast: last,
      beforeLineStyle: timelineTileBeforeLineStyle,
      indicatorStyle: timelineTileIndicatorStyle,
      alignment: TimelineAlign.manual,
      lineXY: 0.65,
      endChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                first
                    ? Icon(
                        Icons.directions_walk,
                        color: CustomColors.green,
                      )
                    : Icon(Icons.directions_bike, color: CustomColors.green),
                SizedBox(width: 3.0),
                Expanded(
                  child: Text(
                    '${distance.ceil()} m',
                    style: CustomTextStyles.timelinePathInfo,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              children: [
                Icon(Icons.access_time, color: CustomColors.green),
                SizedBox(width: 3.0),
                Expanded(
                  child: Text(
                    '${(duration / 60).ceil()} min',
                    style: CustomTextStyles.timelinePathInfo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      startChild: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        )),
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
