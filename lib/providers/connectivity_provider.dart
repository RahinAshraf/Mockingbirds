import 'dart:io';
// import 'package:app_builder/utilities/connectivity_status_enum.dart';
// import 'package:connectivity/connectivity.dart';

//import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:overlay_support/overlay_support.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../utilities/connectivityStatusEnum.dart';

import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier{

  ConnectivityStatus? _connectionStatus;
  ConnectivityStatus? get connectionStatus => _connectionStatus; 
  bool connectionExists = false;
  //getter because _networkState is private, to get from another class use get

  ConnectivityProvider() {
    Connectivity()
        .checkConnectivity()
        .then((value) => connectionChange(value));
    Connectivity().onConnectivityChanged.listen(connectionChange);
  }

  Future<void> connectionChange(ConnectivityResult connectivityResult) async {
    print('Connection status:  $connectivityResult');
    
    if (connectivityResult == ConnectivityResult.mobile){ // || connectivityResult == ConnectivityResult.wifi) {
      _connectionStatus = ConnectivityStatus.Mobile;
      notifyListeners();
    } 
    else if (connectivityResult == ConnectivityResult.wifi) {
      _connectionStatus = ConnectivityStatus.Wifi;
      notifyListeners();
    } 
    else {
      _connectionStatus = ConnectivityStatus.Offline;
      print("No Internet Connection");
      notifyListeners();
    }
    // CHECK IF CONNECTION IS REALLY THERE 
    // -- sometimes network exists but is not connected and this is not identified.
    if (_connectionStatus != ConnectivityStatus.Offline) {
      _checkConnection(connectivityResult);
    }
  }


  Future<bool> _checkConnection(ConnectivityResult connectivityResult) async {
    //bool previousConnection = connectionExists;

    try {
      final result = await InternetAddress.lookup('google.com'); //Tests on a real website
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connectionExists = true;
      } 
      else {
        connectionExists = false;
        print("No Internet Connection");
      }
    } on SocketException catch(_) {
      print("No Internet Connection");
      connectionExists = false;
    }
    //The connection status changed send out an update to all listeners
    // if (previousConnection != connectionExists) {
    //    connectionChangeController.add(connectionExists);
    // }
    return connectionExists;
  }


}