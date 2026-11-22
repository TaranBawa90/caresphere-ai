import 'package:flutter/material.dart';

class NetworkProvider extends ChangeNotifier {
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  void toggleOnlineStatus() {
    _isOnline = !_isOnline;
    notifyListeners();
  }

  void setOnline(bool status) {
    _isOnline = status;
    notifyListeners();
  }
}
