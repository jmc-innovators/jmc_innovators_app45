import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../widgets/root_shell.dart';
import '../screens/exam_papers/exam_papers_screen.dart';
import '../screens/textbooks/textbooks_screen.dart';
import '../screens/videos/videos_screen.dart';
import '../screens/science_lab/science_lab_screen.dart';
import '../screens/math_lab/math_lab_screen.dart';
import '../screens/dictionary/dictionary_screen.dart';
import '../screens/notebook/notebook_screen.dart';
import '../screens/classroom/classroom_screen.dart';
import '../screens/ai_center/ai_center_screen.dart';
import '../screens/admin/admin_screen.dart';
import '../screens/about/about_screen.dart';
import '../screens/contact/contact_screen.dart';

/// Simple named-route table. Splash -> Onboarding -> Login -> RootShell
/// are driven manually (see main.dart's _AppFlow) rather than through
/// named routes, since each depends on runtime state (first launch,
/// auth status) rather than a URL the user navigates to directly.
class AppRouter {
  static Map<String, WidgetBuilder> get routes => {
        '/exam-papers': (_) => const ExamPapersScreen(),
        '/textbooks': (_) => const TextbooksScreen(),
        '/videos': (_) => const VideosScreen(),
        '/science-lab': (_) => const ScienceLabScreen(),
        '/math-lab': (_) => const MathLabScreen(),
        '/dictionary': (_) => const DictionaryScreen(),
        '/notebook': (_) => const NotebookScreen(),
        '/classroom': (_) => const ClassroomScreen(),
        '/ai-center': (_) => const AiCenterScreen(),
        '/admin': (_) => const AdminScreen(),
        '/about': (_) => const AboutScreen(),
        '/contact': (_) => const ContactScreen(),
      };
}
