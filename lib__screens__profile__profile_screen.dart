import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../services/auth_service.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final user = auth.currentUser;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 32, backgroundColor: AppColors.surfaceGlass, child: Icon(Icons.person, color: AppColors.cyan, size: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.displayName ?? 'Student', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                    Text(user?.email ?? 'Not signed in', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _statCard('12', 'Achievements')),
              const SizedBox(width: 12),
              Expanded(child: _statCard('34', 'Downloads')),
              const SizedBox(width: 12),
              Expanded(child: _statCard('87%', 'Progress')),
            ],
          ),
          const SizedBox(height: 20),
          _menuTile(context, Icons.school_rounded, 'Grade & School'),
          _menuTile(context, Icons.emoji_events_rounded, 'Achievements'),
          _menuTile(context, Icons.history_rounded, 'Learning History'),
          _menuTile(context, Icons.bookmark_rounded, 'Bookmarks'),
          _menuTile(context, Icons.settings_rounded, 'Settings', onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
          }),
          _menuTile(context, Icons.logout_rounded, 'Logout', onTap: () => auth.signOut()),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label) => GlassCard(
        child: Column(
          children: [
            Text(value, style: const TextStyle(color: AppColors.cyan, fontSize: 20, fontWeight: FontWeight.w800)),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
      );

  Widget _menuTile(BuildContext context, IconData icon, String label, {VoidCallback? onTap}) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GlassCard(
          onTap: onTap ?? () {},
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
