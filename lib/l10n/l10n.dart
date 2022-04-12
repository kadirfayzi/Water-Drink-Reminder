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
        return '🇺🇸';
      default:
        return '🇺🇸';
    }
  }

  static String getName(String code) {
    switch (code) {
      case 'tr':
        return 'Türkçe';
      case 'es':
        return 'Español';
      case 'de':
        return 'Deutsch';
      case 'en':
        return 'English';
      default:
        return 'English';
    }
  }

  static String getNotificationTitle(String code) {
    switch (code) {
      case 'tr':
        return 'Su içmenin tam zamanı!';
      case 'es':
        return '¡Es hora de beber agua!';
      case 'de':
        return 'Het is tijd om water te drinken!';
      case 'en':
        return 'It\'s time to drink water!';
      default:
        return 'It\'s time to drink water!';
    }
  }

  static String getNotificationBody(String code) {
    switch (code) {
      case 'tr':
        return 'İçtikten sonra onaylamak için bardağa dokunun';
      case 'es':
        return 'Después de beber, toque la taza para confirmar';
      case 'de':
        return 'Raak na het drinken de beker aan om te bevestigen';
      case 'en':
        return 'After drinking, touch the cup to confirm';
      default:
        return 'After drinking, touch the cup to confirm';
    }
  }
}
