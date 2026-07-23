import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// Language / theme choices are UI-only here — wire [onLanguageChanged]
/// and [onThemeChanged] up to a Provider/Riverpod app-settings notifier
/// that persists to SharedPreferences and drives MaterialApp's locale
/// and themeMode from main.dart.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _language = 'English';
  String _themeMode = 'Dark';
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionLabel('Language'),
          GlassCard(
            child: Column(
              children: ['English', 'தமிழ்', 'සිංහල'].map((l) => RadioListTile<String>(
                    value: l, groupValue: _language, onChanged: (v) => setState(() => _language = v!),
                    title: Text(l, style: const TextStyle(color: Colors.white)),
                    activeColor: AppColors.cyan,
                  )).toList(),
            ),
          ),
          const SizedBox(height: 16),
          _sectionLabel('Theme'),
          GlassCard(
            child: Column(
              children: ['Dark', 'Light', 'System'].map((t) => RadioListTile<String>(
                    value: t, groupValue: _themeMode, onChanged: (v) => setState(() => _themeMode = v!),
                    title: Text(t, style: const TextStyle(color: Colors.white)),
                    activeColor: AppColors.cyan,
                  )).toList(),
            ),
          ),
          const SizedBox(height: 16),
          _sectionLabel('Notifications'),
          GlassCard(
            child: SwitchListTile(
              value: _notifications,
              onChanged: (v) => setState(() => _notifications = v),
              title: const Text('Push notifications', style: TextStyle(color: Colors.white)),
              activeColor: AppColors.cyan,
            ),
          ),
          const SizedBox(height: 16),
          _sectionLabel('More'),
          _tile(Icons.privacy_tip_outlined, 'Privacy'),
          _tile(Icons.help_outline_rounded, 'Help'),
          _tile(Icons.info_outline_rounded, 'About'),
          _tile(Icons.mail_outline_rounded, 'Contact'),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w700)),
      );

  Widget _tile(IconData icon, String label) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GlassCard(
          onTap: () {},
          child: Row(
            children: [
              Icon(icon, color: AppColors.purple),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: const TextStyle(color: Colors.white))),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      );
}
