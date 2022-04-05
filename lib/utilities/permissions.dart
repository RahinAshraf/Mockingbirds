import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:veloplan/utilities/enums/location_enums.dart';

/// Handles location permission statuses for the live location of the user
/// Author: Rahin Ashraf
class PermissionUtils {
  BehaviorSubject<Permissions> _locationPermission = BehaviorSubject();
  Stream<Permissions> get locationPermission => _locationPermission.stream;

  static final PermissionUtils _permissionUtils = PermissionUtils._internal();

  static PermissionUtils get instance => _permissionUtils;

  PermissionUtils._internal();

  /// Gets the location permission of the live location of the user
  Stream<Permissions> getLocation(BuildContext context) {
    checkPermissions(context: context);
    return locationPermission;
  }

  /// Checks for the [PermissionStatus] of the user
  void checkPermissions({required BuildContext context}) async {
    final status = await Permission.location.status;
    switch (status) {
      case PermissionStatus.denied:
        _locationPermission.sink.add(Permissions.DENY);
        break;
      case PermissionStatus.granted:
        //do nothing
        _locationPermission.sink.add(Permissions.ALLOW_ALL_TIME);
        break;
      case PermissionStatus.limited:
        _locationPermission.sink.add(Permissions.ALLOW_WHILE_USING_APP);
        break;
      case PermissionStatus.restricted:
        _locationPermission.sink.add(Permissions.ALLOW_WHILE_USING_APP);
        break;
      case PermissionStatus.permanentlyDenied:
        _locationPermission.sink.add(Permissions.DENY);
        break;
    }
  }

  void dispose() {
    _locationPermission.close();
  }
}
