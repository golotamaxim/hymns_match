import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/language_code.dart';
import '../models/translation_entry.dart';
import '../services/hymn_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _hymnService = HymnService();
  final _deController = TextEditingController();
  final _enController = TextEditingController();
  final _ruController = TextEditingController();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _hymnService.initialize();
    _deController.addListener(() => _onChanged(LanguageCode.de, _deController.text));
    _enController.addListener(() => _onChanged(LanguageCode.en, _enController.text));
    _ruController.addListener(() => _onChanged(LanguageCode.ru, _ruController.text));
  }

  @override
  void dispose() {
    _deController.dispose();
    _enController.dispose();
    _ruController.dispose();
    super.dispose();
  }

  void _onChanged(LanguageCode source, String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    if (value.isEmpty) {
      _clearOtherFields(source);
    } else {
      final entry = _hymnService.findByNumber(source, value);
      if (entry != null) {
        _updateFields(source, entry);
      } else {
        _clearOtherFields(source);
      }
    }

    _isUpdating = false;
  }

  void _updateFields(LanguageCode source, TranslationEntry entry) {
    if (source != LanguageCode.de) _deController.text = entry.de;
    if (source != LanguageCode.en) _enController.text = entry.en;
    if (source != LanguageCode.ru) _ruController.text = entry.ru;
  }

  void _clearOtherFields(LanguageCode source) {
    if (source != LanguageCode.de) _deController.text = '';
    if (source != LanguageCode.en) _enController.text = '';
    if (source != LanguageCode.ru) _ruController.text = '';
  }

  Future<void> _shareToWhatsApp() async {
    final de = _deController.text;
    final en = _enController.text;
    final ru = _ruController.text;

    if (de.isEmpty && en.isEmpty && ru.isEmpty) return;

    final message = 'DE $de EN $en RU $ru';
    final encoded = Uri.encodeComponent(message);
    final uri = Uri.parse('https://wa.me/?text=$encoded');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp is not available')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HymnMatch'),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFFAFAFA),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTextField('DE', _deController),
                const SizedBox(height: 16),
                _buildTextField('EN', _enController),
                const SizedBox(height: 16),
                _buildTextField('RU', _ruController),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _shareToWhatsApp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F51B5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Share to WhatsApp'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF3F51B5), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
