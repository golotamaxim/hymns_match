class TranslationEntry {
  final String de;
  final String en;
  final String ru;

  const TranslationEntry({
    required this.de,
    required this.en,
    required this.ru,
  });

  factory TranslationEntry.fromJson(Map<String, dynamic> json) {
    return TranslationEntry(
      de: json['de'] ?? '',
      en: json['en'] ?? '',
      ru: json['ru'] ?? '',
    );
  }
}
