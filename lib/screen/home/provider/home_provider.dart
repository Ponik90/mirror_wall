import 'package:flutter/material.dart';
import 'package:mirror_wall/utils/shared_preference.dart';

class HomeProvider with ChangeNotifier {
  String searchEngine = "google";
  double? progress;
  List<String> bookMark = [];

  void changeSearchEngine(value) {
    searchEngine = value;
    notifyListeners();
  }

  void check(double value) {
    progress = value;
    notifyListeners();
  }

  Future<void> addBookMark(String bookmarkData) async {
    List<String>? data = await getBookMark();
    if (data != null) {
      data.add(bookmarkData);
      setBookMark(data);
    } else {
      setBookMark([bookmarkData]);
    }
    getBookMarkData();
    notifyListeners();
  }

  Future<void> getBookMarkData() async {
    var list = await getBookMark();
    if (list != null) {
      bookMark = list;
      notifyListeners();
    }
  }

  void deleteBookMark(int index) {

    bookMark.removeAt(index);
    setBookMark(bookMark);
    notifyListeners();
  }
}
