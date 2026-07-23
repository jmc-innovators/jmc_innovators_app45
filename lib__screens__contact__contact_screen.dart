import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// Native recreation of tell_us.html ("JMC Innovators - Registration
/// Form") — a short registration/feedback form in the source page's
/// clean blue accent (#0d47a1).
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  static const _blue = Color(0xFF0D47A1);
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _gradeCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _submitted = false;

  Future<void> _submit() async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() => _submitted = true);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Thanks — we\'ve received your details!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: _blue.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.how_to_reg_rounded, color: _blue),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Tell Us About Yourself',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text('Help us personalize your learning experience',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 24),
            _field('Full name', _nameCtrl, Icons.person_outline_rounded),
            const SizedBox(height: 14),
            _field('Email address', _emailCtrl, Icons.mail_outline_rounded,
                keyboard: TextInputType.emailAddress),
            const SizedBox(height: 14),
            _field('Grade (e.g. Grade 10, A/L)', _gradeCtrl, Icons.school_outlined),
            const SizedBox(height: 14),
            TextField(
              controller: _messageCtrl,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'What would you like help with?',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            WonderfulLoadingButton(
              label: _submitted ? 'Submitted' : 'Submit',
              icon: _submitted ? Icons.check_circle_rounded : Icons.send_rounded,
              gradient: LinearGradient(colors: [_blue, AppColors.cyan]),
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String hint, TextEditingController ctrl, IconData icon,
      {TextInputType? keyboard}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
      ),
    );
  }
}
