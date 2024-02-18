import 'package:flutter/widgets.dart';

class MyAppState extends ChangeNotifier {
  bool isAuth = false;
  var preferences = [];
  var history = <String>[];
  int pageSate = 0;

  void setPageSate(int page) {
    pageSate = page;
    notifyListeners();
  }

  void login() {
    isAuth = true;
    notifyListeners();
  }

  void logout() {
    isAuth = false;
    notifyListeners();
  }

  GlobalKey? historyListKey;

  var favorites = [];

  void toggleFavorite([String? recipe]) {
    if (favorites.contains(recipe)) {
      favorites.remove(recipe);
    } else {
      favorites.add(recipe);
    }
    notifyListeners();
  }

  void removeFavorite(String pair) {
    favorites.remove(pair);
    notifyListeners();
  }

  void toggelPreference([List<String>? pref]) {
    for (var element in pref!) {
      if (pref.contains(element)) {
        pref.remove(element);
      }
      pref.add(element);
    }
    // preferences.remove(pref);
    notifyListeners();
    // preferences.addAll(pref!);
    // if (preferences.contains(pref)) {
    //   preferences.remove(pref);
    // } else {
    //   preferences.add(pref);
    // }
    notifyListeners();
  }

  // void removePreference([List<String>? pref]) {
  //   for (var element in pref!) {
  //     pref.remove(element);
  //   }
  //   // preferences.remove(pref);
  //   notifyListeners();
  // }
}
