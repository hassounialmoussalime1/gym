// ignore: deprecated_member_use
import 'dart:html' as html;
import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // اللغة الافتراضية

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  void setLocale(Locale locale) {
    if (_locale == locale) return;

    _locale = locale;

    // 🔐 حفظ اللغة في LocalStorage
    html.window.localStorage['app_lang'] = locale.languageCode;

    notifyListeners();
  }

  void _loadSavedLocale() {
    final savedLang = html.window.localStorage['app_lang'];

    if (savedLang != null && savedLang.isNotEmpty) {
      _locale = Locale(savedLang);
      notifyListeners();
    }
  }
}
