import 'package:flutter/cupertino.dart';
import 'package:app/lang/abs_lan.dart';
import 'package:app/lang/lang_en.dart';
import 'package:app/lang/lang_hi.dart';
import 'package:app/lang/lang_kn.dart';
import 'package:app/lang/lang_mr.dart';
import 'package:app/lang/lang_ta.dart';
import 'package:app/lang/lang_bn.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'hi', 'mr', 'kn', 'ta', 'bn'].contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) => _load(locale);

  static Future<Languages> _load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'hi':
        return LanguageHi();
      case 'kn':
        return LanguageKn();
      case 'mr':
        return LanguageMr();
      case 'ta':
        return LanguageTa();
      case 'bn':
        return LanguageBn();
      default:
        return LanguageEn();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Languages> old) => false;
}
