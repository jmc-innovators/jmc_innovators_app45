import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../services/ai_service.dart';

class _ChatMessage {
  final String text;
  final bool fromUser;
  _ChatMessage(this.text, this.fromUser);
}

class AiCenterScreen extends StatefulWidget {
  const AiCenterScreen({super.key});

  @override
  State<AiCenterScreen> createState() => _AiCenterScreenState();
}

class _AiCenterScreenState extends State<AiCenterScreen> {
  final _ai = AiService();
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<_ChatMessage> _messages = [];
  String _mode = 'Chat';
  bool _sending = false;

  static const _modes = [
    'Chat', 'Homework Help', 'Math Solver', 'Science Tutor',
    'Programming Assistant', 'Translation', 'Summarization',
  ];

  Future<void> _send() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() {
      _messages.add(_ChatMessage(text, true));
      _sending = true;
      _inputCtrl.clear();
    });
    _scrollToBottom();
    try {
      final reply = await _ai.sendMessage(message: text, mode: _mode);
      setState(() => _messages.add(_ChatMessage(reply, false)));
    } catch (e) {
      setState(() => _messages.add(_ChatMessage(
          '⚠️ Could not reach the AI backend. Check AI_BASE_URL configuration.\n\n_${e.toString()}_',
          false)));
    } finally {
      setState(() => _sending = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                const Icon(Icons.smart_toy_rounded, color: AppColors.cyan),
                const SizedBox(width: 8),
                const Text('AI Center',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.mic_rounded, color: Colors.white)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.attach_file_rounded, color: Colors.white)),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _modes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = _modes[i] == _mode;
                return ChoiceChip(
                  label: Text(_modes[i]),
                  selected: selected,
                  onSelected: (_) => setState(() => _mode = _modes[i]),
                  selectedColor: AppColors.cyan,
                  backgroundColor: AppColors.surfaceGlass,
                  labelStyle: TextStyle(color: selected ? Colors.black : Colors.white70),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text('Ask me anything about your studies',
                        style: TextStyle(color: AppColors.textSecondary)))
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _messages.length,
                    itemBuilder: (context, i) {
                      final m = _messages[i];
                      return Align(
                        alignment: m.fromUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: m.fromUser ? AppColors.aurora : null,
                            color: m.fromUser ? null : AppColors.surfaceGlass,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: m.fromUser
                              ? Text(m.text, style: const TextStyle(color: Colors.black))
                              : MarkdownBody(
                                  data: m.text,
                                  styleSheet: MarkdownStyleSheet(
                                    p: const TextStyle(color: Colors.white),
                                    code: const TextStyle(
                                        color: AppColors.cyan, backgroundColor: Colors.black26),
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
          ),
          if (_sending)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('JARK AI is typing…',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Message JARK AI...'),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  IconButton(
                    onPressed: _sending ? null : _send,
                    icon: const Icon(Icons.send_rounded, color: AppColors.cyan),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
