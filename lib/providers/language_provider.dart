import 'package:flutter/material.dart';
import '../core/constants/app_strings.dart';
import '../core/services/local_storage_service.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  LanguageProvider() {
    _loadLanguage();
  }

  void _loadLanguage() {
    _currentLanguage = LocalStorageService.getLanguage();
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    if (_currentLanguage != lang) {
      _currentLanguage = lang;
      await LocalStorageService.setLanguage(lang);
      notifyListeners();
    }
  }

  String tr(String key) {
    return AppStrings.get(key, _currentLanguage);
  }

  String get languageName {
    switch (_currentLanguage) {
      case 'hi':
        return 'हिन्दी (Hindi)';
      case 'pa':
        return 'ਪੰਜਾਬੀ (Punjabi)';
      default:
        return 'English';
    }
  }
}
