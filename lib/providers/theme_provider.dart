import 'package:flutter/material.dart';
import '../core/services/local_storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isSimpleMode = false;
  double _textScale = 1.0;

  bool get isDarkMode => _isDarkMode;
  bool get isSimpleMode => _isSimpleMode;
  double get textScale => _textScale;

  ThemeProvider() {
    _loadSettings();
  }

  void _loadSettings() {
    _isDarkMode = LocalStorageService.isDarkMode();
    _isSimpleMode = LocalStorageService.isSimpleMode();
    _textScale = LocalStorageService.getTextScale();
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await LocalStorageService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> toggleSimpleMode() async {
    _isSimpleMode = !_isSimpleMode;
    await LocalStorageService.setSimpleMode(_isSimpleMode);
    notifyListeners();
  }

  Future<void> setTextScale(double scale) async {
    _textScale = scale.clamp(0.85, 1.4);
    await LocalStorageService.setTextScale(_textScale);
    notifyListeners();
  }
}
