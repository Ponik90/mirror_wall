import 'package:shared_preferences/shared_preferences.dart';

Future<void> setBookMark(List<String> listData) async {
  SharedPreferences bookMarkList = await SharedPreferences.getInstance();
  await bookMarkList.setStringList('bookMark', listData);
}

Future<List<String>?> getBookMark() async {
  List<String>? data = [];
  SharedPreferences bookMarkList = await SharedPreferences.getInstance();
  data = bookMarkList.getStringList('bookMark');
  return data;
}