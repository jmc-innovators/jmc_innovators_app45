import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  static const _categories = [
    ('Exam Papers', Icons.description_rounded, '/exam-papers'),
    ('Textbooks', Icons.menu_book_rounded, '/textbooks'),
    ('Educational Videos', Icons.play_circle_rounded, '/videos'),
    ('Science Lab', Icons.biotech_rounded, '/science-lab'),
    ('Math Lab', Icons.functions_rounded, '/math-lab'),
    ('Dictionary', Icons.translate_rounded, '/dictionary'),
    ('AI Notebook', Icons.note_alt_rounded, '/notebook'),
    ('JMC Classroom', Icons.school_rounded, '/classroom'),
    ('AI Center', Icons.smart_toy_rounded, '/ai-center'),
    ('Assignments', Icons.assignment_rounded, '/classroom'),
    ('Quizzes', Icons.quiz_rounded, '/classroom'),
    ('Announcements', Icons.campaign_rounded, '/classroom'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text('Explore',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.15,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, i) {
                final (label, icon, route) = _categories[i];
                return GlassCard(
                  onTap: () => Navigator.of(context).pushNamed(route),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: AppColors.aurora,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: Colors.black),
                      ),
                      const Spacer(),
                      Text(label,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
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
}
