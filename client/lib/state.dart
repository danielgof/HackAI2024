import 'package:english_words/english_words.dart';
import 'package:flutter/widgets.dart';

class MyAppState extends ChangeNotifier {
  bool isAuth = false;
  var current = WordPair.random();
  var history = <WordPair>[];
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

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}
