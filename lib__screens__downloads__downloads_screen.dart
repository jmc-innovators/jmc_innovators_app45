import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// Aggregated offline-downloaded content (exam papers, textbooks, notes).
/// Wire to path_provider + a local manifest (SharedPreferences/Hive) that
/// each download-capable screen writes to when a user taps "download".
class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Combined Maths Paper I.pdf', '2.1 MB'),
      ('Science Textbook - Grade 10.pdf', '18.4 MB'),
    ];
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text('Downloads', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: items.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassCard(
                  child: Row(
                    children: [
                      const Icon(Icons.insert_drive_file_rounded, color: AppColors.cyan),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(items[i].$1, style: const TextStyle(color: Colors.white)),
                            Text(items[i].$2, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.delete_outline, color: AppColors.danger), onPressed: () {}),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
