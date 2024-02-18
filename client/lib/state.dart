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
    // pair = pair ?? current;
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

  void toggelPreference([String? pref]) {
    if (preferences.contains(pref)) {
      preferences.remove(pref);
    } else {
      preferences.add(pref);
    }
    notifyListeners();
  }

  void removePreference([String? pref]) {
    preferences.remove(pref);
    notifyListeners();
  }
}
