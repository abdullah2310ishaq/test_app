import 'package:flutter/foundation.dart';

/// Which tab is selected in the main bottom navigation shell (0–3).
class BottomNavNotifier extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (index < 0 || index > 3 || index == _currentIndex) {
      return;
    }
    _currentIndex = index;
    notifyListeners();
  }
}
