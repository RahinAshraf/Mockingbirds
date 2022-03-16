import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../utilities/connectivity_status_enums.dart';

/// Connectivity Provider to identify internet connection changes.
/// Author(s): Fariha Choudhury k20059723

/// Checks connection status and listens in on if connection has changed.
/// Notifies listeners upon any changes.
class ConnectivityProvider extends ChangeNotifier {
  ConnectivityStatus? _connectionStatus;
  ConnectivityStatus? get connectionStatus => _connectionStatus;
  bool connectionExists = false;

  ConnectivityProvider() {
    Connectivity().checkConnectivity().then((value) => connectionChange(value));
    Connectivity().onConnectivityChanged.listen(connectionChange);
  }

  /// Notifies listens of the type of [connectivityResult] that was found.
  /// Checks connection type and updates [_connectionStatus].
  Future<void> connectionChange(ConnectivityResult connectivityResult) async {
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        _connectionStatus = ConnectivityStatus.Mobile;
        notifyListeners();
        checkConnection(connectivityResult);
        return;
      case ConnectivityResult.wifi:
        _connectionStatus = ConnectivityStatus.Wifi;
        notifyListeners();
        checkConnection(connectivityResult);
        return;
      case ConnectivityResult.none:
        _connectionStatus = ConnectivityStatus.Offline;
        notifyListeners();
        return;
      default:
        _connectionStatus = ConnectivityStatus.Offline;
        notifyListeners();
        return;
    }
  }

  /// Checks if connection exists by making internet lookups
  Future<bool> checkConnection(ConnectivityResult connectivityResult) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connectionExists = true;
      } else {
        connectionExists = false;
        print("No Internet Connection");
      }
    } on SocketException catch (_) {
      print("No Internet Connection");
      connectionExists = false;
    }
    return connectionExists;
  }
}
