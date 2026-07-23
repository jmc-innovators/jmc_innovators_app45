import 'dart:convert';
import 'package:http/http.dart' as http;

/// Talks to the JARK AI backend (Node/Express + Groq, llama-3.3-70b-versatile)
/// that the team already built and runs for the web app. Reusing it here
/// avoids standing up a second AI backend just for the mobile app.
///
/// Point [baseUrl] at your deployed JARK AI backend, e.g.
/// https://jark-ai-backend.onrender.com — set this via --dart-define
/// (AI_BASE_URL) instead of hardcoding a real URL in source control.
class AiService {
  final String baseUrl;
  AiService({String? baseUrl})
      : baseUrl = baseUrl ??
            const String.fromEnvironment('AI_BASE_URL',
                defaultValue: 'https://your-jark-ai-backend.example.com');

  /// modes mirror JARK AI's existing Chat / Summarize / Code Help,
  /// extended here with Homework Help, Math Solver, Science Tutor,
  /// Translation to match this app's AI Center feature list.
  Future<String> sendMessage({
    required String message,
    required String mode,
    List<Map<String, String>> history = const [],
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'message': message,
        'mode': mode,
        'history': history,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('AI backend error: ${response.statusCode}');
    }
    final data = jsonDecode(response.body);
    // Backend is expected to return { "reply": "..." } — adjust the key
    // here if your JARK AI Express route names the field differently.
    return data['reply'] as String? ?? '';
  }
}
