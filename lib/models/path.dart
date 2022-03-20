import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart'
    as LatLong;
import 'package:veloplan/models/docking_station.dart';

class Path {
  final DockingStation doc1;
  final LatLong.LatLng des1;
  final LatLong.LatLng des2;
  final DockingStation doc2;
  double distance = 0.0;
  double duration = 0;

/**
 * A constructor that is useful for dock sorting paths in edit dock screen
 * 
 */
  Path.dock_sorter(this.des1, this.doc1, this.distance, this.duration)
      : des2 = LatLong.LatLng(0.0, 0.0),
        doc2 = DockingStation.empty();
  Path(this.doc1, this.doc2, this.des1, this.des2);
  Path.api(
      this.doc1, this.doc2, this.des1, this.des2, this.distance, this.duration);

  double getDistace() {
    return distance;
  }

  double getDuration() {
    return duration;
  }

  DockingStation getDock1() {
    return this.doc1;
  }
}
