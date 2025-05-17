import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hideBottomNavigationProvider =
ChangeNotifierProvider<HideBottomNavigation>((ref) {
  return HideBottomNavigation();
});

class HideBottomNavigation extends ChangeNotifier {
  HideBottomNavigation();

  static const List<String> hideBottomNavigationPageList = [
    '/test_templates',
    '/random',
    '/marathon'
  ];

  bool _isHidden = false;

  bool get isHidden => _isHidden;

  // Метод для обновления состояния видимости
  void updateVisibility(String currentPath) {
    final shouldHide = hideBottomNavigationPageList.any((path) =>
      currentPath == path || currentPath.startsWith('$path/'));
    if (_isHidden != shouldHide) {
      _isHidden = shouldHide;
      notifyListeners();
    }
  }
}
