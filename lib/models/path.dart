import 'package:latlong2/latlong.dart';
import 'package:veloplan/models/docking_station.dart';

class Path {
  //final DockingStation doc1;
  final LatLng? des1;
  final LatLng? des2;
  // final DockingStation doc2;
  final double distance = 0.0;
  final int duration = 0;

  Path(this.des1, this.des2);
  // Path._whole(this.doc1, this.doc2, this.des1, this.des2);
}
