import 'package:flutter/foundation.dart';

class ShellNavigationProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void setIndex(int value) {
    if (_index == value) {
      return;
    }
    _index = value;
    notifyListeners();
  }
}
