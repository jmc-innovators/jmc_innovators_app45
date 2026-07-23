import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// Native recreation of text_books.html — grade-grouped Sri Lankan
/// textbook library, emerald/blue accent matching the source page.
class TextbooksScreen extends StatefulWidget {
  const TextbooksScreen({super.key});

  @override
  State<TextbooksScreen> createState() => _TextbooksScreenState();
}

class _TextbooksScreenState extends State<TextbooksScreen> {
  static const _emerald = Color(0xFF10B981);
  static const _blue = Color(0xFF3B82F6);

  int _selectedGrade = 10;
  final _grades = const [6, 7, 8, 9, 10, 11];

  final _subjectsByGrade = const {
    6: ['Mathematics', 'Science', 'English', 'Sinhala', 'History'],
    7: ['Mathematics', 'Science', 'English', 'Sinhala', 'Geography'],
    8: ['Mathematics', 'Science', 'English', 'ICT', 'Health Science'],
    9: ['Mathematics', 'Science', 'English', 'ICT', 'Civics'],
    10: ['Combined Maths', 'Science', 'English', 'ICT', 'Commerce'],
    11: ['Combined Maths', 'Science', 'English', 'ICT', 'Business Studies'],
  };

  @override
  Widget build(BuildContext context) {
    final subjects = _subjectsByGrade[_selectedGrade]!;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text('Sri Lankan Textbooks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Official syllabus textbooks, grade by grade',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _grades.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final grade = _grades[i];
                final active = grade == _selectedGrade;
                return GestureDetector(
                  onTap: () => setState(() => _selectedGrade = grade),
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      gradient: active ? AppColors.aurora : null,
                      color: active ? null : AppColors.surfaceGlass,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text('G$grade',
                        style: TextStyle(
                            color: active ? Colors.black : Colors.white,
                            fontWeight: FontWeight.w800)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: subjects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final subject = subjects[i];
                final color = i.isEven ? _emerald : _blue;
                return GlassCard(
                  onTap: () => _showBook(subject, color),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 60,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.menu_book_rounded, color: color),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(subject,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                            Text('Grade $_selectedGrade · PDF & online reader',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
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

  void _showBook(String subject, Color color) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$subject — Grade $_selectedGrade',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: color),
                    icon: const Icon(Icons.menu_book_rounded, size: 18),
                    label: const Text('Read Online'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: const Text('Download'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
