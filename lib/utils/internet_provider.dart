import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetProvider with ChangeNotifier {
  Connectivity connectivity = Connectivity();
  bool isInternetOn = false;

  void checkInternet() async {
    connectivity.onConnectivityChanged.listen(
          (event) {
        if (event.contains(ConnectivityResult.none)) {
          print("Internet is off ");
          isInternetOn = false;
        } else {
          print("Internet is on");
          isInternetOn = true;
        }
        notifyListeners();
      },
    );
  }
}
