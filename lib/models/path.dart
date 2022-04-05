import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart'
    as LatLong;
import 'package:veloplan/models/docking_station.dart';
import 'package:veloplan/providers/location_service.dart';

/// Creates a common path between two points, a point and a docking station,
/// docking station and a docking station. It stores the durations and distances
/// and updates them when called with the path provider.
class Path {
  final DockingStation doc1;
  String des1Name;
  final LatLong.LatLng des1;
  final LatLong.LatLng des2;
  String des2Name;
  final DockingStation doc2;
  double distance = 0.0;
  double duration = 0;

  /// A constructor that is useful for dock sorting paths in edit dock screen
  Path.dock_sorter(this.des1, this.doc1, this.distance, this.duration)
      : des2 = LatLong.LatLng(0.0, 0.0),
        doc2 = DockingStation.empty(),
        des1Name = "",
        des2Name = "";
  Path(this.doc1, this.doc2, this.des1, this.des2)
      : des1Name = "",
        des2Name = "" {
    _generateNames();
  }
  Path.api(
      this.doc1, this.doc2, this.des1, this.des2, this.distance, this.duration)
      : des1Name = "",
        des2Name = "" {
    _generateNames();
  }

  double getDistace() {
    return distance;
  }

  double getDuration() {
    return duration;
  }

  DockingStation getDock1() {
    return this.doc1;
  }

  /// Generate the names of the paths from coordinates
  Future<void> _generateNames() async {
    LocationService service = LocationService();
    service
        .reverseGeoCode(des1.latitude, des1.longitude)
        .then((value) => initialiseDock1(value['place']));
    service
        .reverseGeoCode(des2.latitude, des2.longitude)
        .then((value) => initialiseDock2(value['place']));
  }

  void initialiseDock1(var place) {
    this.des1Name = place;
  }

  void initialiseDock2(var place) {
    this.des2Name = place;
  }

  void printPath() {
    print("-----path:  des1: " +
        des1.toString() +
        " des2: " +
        des2.toString() +
        " dock1: " +
        doc1.name.toString() +
        "   " +
        doc1.getLatlng().toString() +
        " dock2: " +
        doc2.name.toString() +
        "   " +
        doc2.getLatlng().toString() +
        " distance: " +
        distance.toString() +
        " . duration:  " +
        duration.toString() +
        " ");
  }
}
