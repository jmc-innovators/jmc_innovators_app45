import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// Native recreation of classroom.html — a GitHub-Classroom-style hub:
/// subject channels, live sessions, and assignments, in the site's dark
/// teal/blue/green palette (#0d1117, #1f6feb, #238636).
class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  static const _teal = Color(0xFF1A7F74);
  static const _blue = Color(0xFF1F6FEB);
  static const _green = Color(0xFF238636);

  final _subjects = const [
    ('Combined Mathematics', Icons.functions_rounded, _blue, '12 lessons'),
    ('Physics', Icons.bolt_rounded, _teal, '9 lessons'),
    ('Chemistry', Icons.science_rounded, _green, '8 lessons'),
    ('Biology', Icons.biotech_rounded, _blue, '10 lessons'),
    ('ICT', Icons.computer_rounded, _teal, '14 lessons'),
    ('English', Icons.menu_book_rounded, _green, '6 lessons'),
  ];

  final _liveSessions = const [
    ('Grade 11 · Combined Maths', 'Live now · Mr. Perera', true),
    ('Grade 10 · Science Revision', 'Today, 4:00 PM', false),
    ('Grade 9 · ICT Practical', 'Tomorrow, 3:30 PM', false),
  ];

  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _blue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.school_rounded, color: _blue),
                ),
                const SizedBox(width: 12),
                const Text('JMC Classroom',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _tabChip('Subjects', 0),
                const SizedBox(width: 8),
                _tabChip('Live & Schedule', 1),
                const SizedBox(width: 8),
                _tabChip('Assignments', 2),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: IndexedStack(
              index: _tab,
              children: [_subjectsGrid(), _liveList(), _assignments()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabChip(String label, int i) {
    final active = _tab == i;
    return GestureDetector(
      onTap: () => setState(() => _tab = i),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? _blue : AppColors.surfaceGlass,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(label,
            style: TextStyle(
                color: active ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 13)),
      ),
    );
  }

  Widget _subjectsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.2,
      ),
      itemCount: _subjects.length,
      itemBuilder: (context, i) {
        final (title, icon, color, meta) = _subjects[i];
        return GlassCard(
          onTap: () => _openSubject(title, color),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.18), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color),
              ),
              const Spacer(),
              Text(title,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 4),
              Text(meta, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            ],
          ),
        );
      },
    );
  }

  Widget _liveList() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _liveSessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final (title, time, live) = _liveSessions[i];
        return GlassCard(
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: live ? _green : AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    Text(time, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: live ? _green : _blue,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                child: Text(live ? 'Join' : 'Remind me', style: const TextStyle(fontSize: 12)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _assignments() {
    final items = [
      ('Algebra Worksheet 4', 'Due Fri · Combined Maths', false),
      ('Lab Report: Titration', 'Due Mon · Chemistry', false),
      ('ICT Practical Submission', 'Submitted', true),
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final (title, meta, done) = items[i];
        return GlassCard(
          child: Row(
            children: [
              Icon(done ? Icons.check_circle_rounded : Icons.assignment_rounded,
                  color: done ? _green : _blue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    Text(meta, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openSubject(String title, Color color) {
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
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Lesson materials, recordings, and notes for this subject will appear here once synced with JMC Classroom.',
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: color),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
