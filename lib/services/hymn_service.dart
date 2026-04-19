import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/language_code.dart';
import '../models/translation_entry.dart';

class HymnService {
  static final HymnService _instance = HymnService._internal();
  factory HymnService() => _instance;
  HymnService._internal();

  final Map<String, TranslationEntry> _deIndex = {};
  final Map<String, TranslationEntry> _enIndex = {};
  final Map<String, TranslationEntry> _ruIndex = {};
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    final String data = await rootBundle.loadString('assets/numbers.json');
    final List<dynamic> jsonList = json.decode(data);
    for (final item in jsonList) {
      final entry = TranslationEntry.fromJson(item as Map<String, dynamic>);
      if (entry.de.isNotEmpty) _deIndex[entry.de] = entry;
      if (entry.en.isNotEmpty) _enIndex[entry.en] = entry;
      if (entry.ru.isNotEmpty) _ruIndex[entry.ru] = entry;
    }
    _initialized = true;
  }

  TranslationEntry? findByNumber(LanguageCode language, String number) {
    if (number.isEmpty) return null;
    return switch (language) {
      LanguageCode.de => _deIndex[number],
      LanguageCode.en => _enIndex[number],
      LanguageCode.ru => _ruIndex[number],
    };
  }
}
