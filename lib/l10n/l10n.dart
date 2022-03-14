import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('tr'),
    const Locale('es'),
    const Locale('de'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'tr':
        return '🇹🇷';
      case 'es':
        return '🇪🇸';
      case 'de':
        return '🇩🇪';
      case 'en':
      default:
        return '🇺🇸';
    }
  }
}
