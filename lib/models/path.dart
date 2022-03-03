import 'package:latlong2/latlong.dart';
import 'package:veloplan/models/docking_station.dart';

class Path {
  //final DockingStation doc1;
  final LatLng? doc1;
  final LatLng? doc2;
  //final DockingStation doc2;
  final double distance = 0.0;
  final int duration = 0;

  Path(this.doc1, this.doc2);
}
