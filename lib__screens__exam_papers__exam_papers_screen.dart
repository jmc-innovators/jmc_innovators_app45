import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// Native recreation of exampapers.html — grade + subject filterable list
/// of Sri Lankan exam papers, green/indigo accent to match the source page.
class ExamPapersScreen extends StatefulWidget {
  const ExamPapersScreen({super.key});

  @override
  State<ExamPapersScreen> createState() => _ExamPapersScreenState();
}

class _ExamPapersScreenState extends State<ExamPapersScreen> {
  static const _green = Color(0xFF16A34A);
  static const _indigo = Color(0xFF4F46E5);

  final _grades = const ['All', 'Grade 9', 'Grade 10', 'Grade 11', 'A/L'];
  String _selectedGrade = 'All';
  bool _downloading = false;

  final _papers = const [
    ('Combined Maths Model Paper', 'A/L · 2025', Icons.functions_rounded),
    ('Science Term 3 Past Paper', 'Grade 10 · 2024', Icons.science_rounded),
    ('English Language Paper', 'Grade 11 · 2024', Icons.menu_book_rounded),
    ('ICT Structured Questions', 'A/L · 2025', Icons.computer_rounded),
    ('Sinhala Language Paper', 'Grade 9 · 2024', Icons.translate_rounded),
    ('Physics Essay & Structured', 'A/L · 2025', Icons.bolt_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text('Sri Lanka Exam Papers',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Past papers and model papers by grade and subject',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _grades.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final grade = _grades[i];
                final active = grade == _selectedGrade;
                return GestureDetector(
                  onTap: () => setState(() => _selectedGrade = grade),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? _green : AppColors.surfaceGlass,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(grade,
                        style: TextStyle(
                            color: active ? Colors.white : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _papers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final (title, meta, icon) = _papers[i];
                return GlassCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: _indigo.withOpacity(0.18), borderRadius: BorderRadius.circular(12)),
                        child: Icon(icon, color: _indigo),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            Text(meta, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                      _DownloadButton(color: _green, onDownload: _simulateDownload),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _simulateDownload() async {
    if (_downloading) return;
    setState(() => _downloading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() => _downloading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Saved to Downloads')));
    }
  }
}

/// A small per-item "wonderful loading button": shows a spinner in place
/// of the icon while the (simulated) download runs, then a check mark.
class _DownloadButton extends StatefulWidget {
  final Color color;
  final Future<void> Function() onDownload;
  const _DownloadButton({required this.color, required this.onDownload});

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  bool _loading = false;
  bool _done = false;

  Future<void> _tap() async {
    if (_loading) return;
    setState(() => _loading = true);
    await widget.onDownload();
    if (mounted) setState(() {
      _loading = false;
      _done = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: IconButton(
        key: ValueKey(_loading ? 'loading' : (_done ? 'done' : 'idle')),
        onPressed: _tap,
        icon: _loading
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: widget.color))
            : Icon(_done ? Icons.check_circle_rounded : Icons.download_rounded,
                color: widget.color),
      ),
    );
  }
}
