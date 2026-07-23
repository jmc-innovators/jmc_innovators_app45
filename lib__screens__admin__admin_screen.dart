import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// Admin panel shell. Gate this route behind a Firestore custom-claim
/// or role field (e.g. users/{uid}.role == 'admin') checked in the
/// router's redirect, not just by hiding the menu entry client-side.
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  static const _sections = [
    ('Manage Users', Icons.people_alt_rounded),
    ('Manage Exam Papers', Icons.description_rounded),
    ('Manage Textbooks', Icons.menu_book_rounded),
    ('Manage Videos', Icons.video_library_rounded),
    ('Manage Announcements', Icons.campaign_rounded),
    ('Manage Quizzes', Icons.quiz_rounded),
    ('Manage AI Prompts', Icons.smart_toy_rounded),
    ('View Analytics', Icons.bar_chart_rounded),
    ('Upload / Delete Files', Icons.upload_file_rounded),
    ('Manage Notifications', Icons.notifications_active_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Admin Panel')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.3,
        ),
        itemCount: _sections.length,
        itemBuilder: (context, i) => GlassCard(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_sections[i].$2, color: AppColors.cyan),
              const Spacer(),
              Text(_sections[i].$1, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
