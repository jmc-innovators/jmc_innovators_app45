import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// Native recreation of dictionary_.html — a simple, fast word lookup
/// tool, in the source page's clean green accent (#4CAF50).
class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  static const _green = Color(0xFF4CAF50);
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;
  Map<String, dynamic>? _result;

  Future<void> _lookup() async {
    final word = _controller.text.trim();
    if (word.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });
    try {
      final res = await http.get(
          Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        setState(() => _result = data.first as Map<String, dynamic>);
      } else {
        setState(() => _error = 'No definition found for "$word"');
      }
    } catch (e) {
      setState(() => _error = 'Could not reach the dictionary service');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(color: _green.withOpacity(0.18), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.translate_rounded, color: _green),
                ),
                const SizedBox(width: 12),
                const Text('Dictionary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              onSubmitted: (_) => _lookup(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search a word...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: IconButton(
                  onPressed: _loading ? null : _lookup,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _loading
                        ? const SizedBox(
                            key: ValueKey('loading'),
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: _green))
                        : const Icon(Icons.arrow_forward_rounded, key: ValueKey('idle'), color: _green),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildResult()),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: _green));
    }
    if (_error != null) {
      return Center(
          child: Text(_error!, style: const TextStyle(color: AppColors.textSecondary)));
    }
    if (_result == null) {
      return const Center(
        child: Text('Look up any English word to see its meaning,\npart of speech, and example usage.',
            textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    final word = _result!['word'] as String;
    final phonetic = _result!['phonetic'] as String? ?? '';
    final meanings = (_result!['meanings'] as List).cast<Map<String, dynamic>>();
    return SingleChildScrollView(
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(word,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(width: 10),
                if (phonetic.isNotEmpty)
                  Text(phonetic, style: const TextStyle(color: _green, fontStyle: FontStyle.italic)),
              ],
            ),
            const Divider(color: Colors.white24, height: 24),
            for (final m in meanings) ...[
              Text(m['partOfSpeech'] as String,
                  style: const TextStyle(
                      color: _green, fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 6),
              for (final d in ((m['definitions'] as List).take(2)))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('• ${d['definition']}',
                      style: const TextStyle(color: Colors.white, height: 1.4)),
                ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

