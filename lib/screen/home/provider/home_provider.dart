import 'package:flutter/material.dart';
import 'package:mirror_wall/utils/shared_preference.dart';

class HomeProvider with ChangeNotifier {
  String searchEngine = "google";
  double? progress;
  List<String> bookMark= [];

  void changeSearchEngine(value) {
    searchEngine = value;
    notifyListeners();
  }

  void check(double value) {
    progress = value;
    notifyListeners();
  }

  Future<void> addBookMark(String bookmarkData)
  async {
    if(getBookMark()!=null)
      {
        bookMark=(await getBookMark())!;

        if(bookMark!=null)
          {
            bookMark.add(bookmarkData);
            setBookMark(bookMark);
          }
      }
  }
}
