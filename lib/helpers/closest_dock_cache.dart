import 'package:mapbox_gl/mapbox_gl.dart';

class ClosestDockCache {

  Map<LatLng, LatLng> _cache = {};

  static final ClosestDockCache _closestDockCache  = ClosestDockCache._internal();

  static  ClosestDockCache get instance =>_closestDockCache;

  ClosestDockCache._internal();

  void cache(LatLng mainLatLng, LatLng closesDock){
    _cache[mainLatLng] = closesDock;
    print("MAPPING : $_cache \n $mainLatLng _ $closesDock");
  }

  LatLng? get(LatLng mainLatLng){
    final closestDock = _cache[mainLatLng];
    print("MAPPING2 : $_cache \n $mainLatLng _ $closestDock");
    return closestDock;
  }

  void remove(int removeKey){
    _cache.removeWhere((key, value) => key == removeKey);
  }

  void clear(){
    _cache.clear();
  }

}