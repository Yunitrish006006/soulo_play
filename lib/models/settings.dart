import 'package:flutter/material.dart';

class SettingsModel extends ChangeNotifier {
  double _fontScale = 1.0;
  bool _isDark = false;

  double get fontScale => _fontScale;
  bool get isDark => _isDark;

  void setFontScale(double scale) {
    _fontScale = scale;
    notifyListeners();
  }

  void toggleDark(bool value) {
    _isDark = value;
    notifyListeners();
  }
}
