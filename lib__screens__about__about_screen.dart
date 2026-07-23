import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('About')),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'JMC Innovators Learning Platform is an AI-powered education app built for '
          'Grade 6-11 students in Sri Lanka, offering exam papers, textbooks, smart tools, '
          'and an always-on AI tutor — built by a four-person student developer team.',
          style: TextStyle(color: AppColors.textSecondary, height: 1.5),
        ),
      ),
    );
  }
}
