import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  String searchEngine = "google";
  double? progress;

  void changeSearchEngine(value) {
    searchEngine = value;
    notifyListeners();
  }

  void check(double value) {
    progress = value;
    notifyListeners();
  }
}
