import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetProvider with ChangeNotifier {
  Connectivity connectivity = Connectivity();
  bool isInternetOn = false;

  void checkInternet() async {
    connectivity.onConnectivityChanged.listen(
          (event) {
        if (event.contains(ConnectivityResult.none)) {

          isInternetOn = false;
        } else {

          isInternetOn = true;
        }
        notifyListeners();
      },
    );
  }
}
