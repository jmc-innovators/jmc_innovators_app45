import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../services/ai_service.dart';

/// Native recreation of notebook.html (JMC AI Notebook) — a NotebookLM-style
/// tool: a list of notebooks, each with sources and an AI chat that
/// answers using only what's inside that notebook.
class NotebookScreen extends StatefulWidget {
  const NotebookScreen({super.key});

  @override
  State<NotebookScreen> createState() => _NotebookScreenState();
}

class _Notebook {
  String name;
  List<String> sources;
  _Notebook(this.name, this.sources);
}

class _NotebookScreenState extends State<NotebookScreen> {
  final _notebooks = [
    _Notebook('Grade 11 — Combined Maths', ['Textbook Ch. 4', 'Past Paper 2024']),
    _Notebook('Science Revision Notes', ['Cell Biology Notes.pdf']),
  ];
  int? _openIndex;

  @override
  Widget build(BuildContext context) {
    if (_openIndex != null) {
      return _NotebookDetail(
        notebook: _notebooks[_openIndex!],
        onBack: () => setState(() => _openIndex = null),
      );
    }
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text('AI Notebook',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
                IconButton(
                  onPressed: _createNotebook,
                  icon: const Icon(Icons.add_circle_rounded, color: AppColors.cyan, size: 28),
                ),
              ],
            ),
          ),
          Expanded(
            child: _notebooks.isEmpty
                ? const Center(
                    child: Text('Start by adding a source',
                        style: TextStyle(color: AppColors.textSecondary)))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _notebooks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final nb = _notebooks[i];
                      return GlassCard(
                        onTap: () => setState(() => _openIndex = i),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  gradient: AppColors.aurora, borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.auto_stories_rounded, color: Colors.black),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(nb.name,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                  Text('${nb.sources.length} sources',
                                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
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

  void _createNotebook() {
    setState(() => _notebooks.add(_Notebook('New Notebook', [])));
    setState(() => _openIndex = _notebooks.length - 1);
  }
}

class _NotebookDetail extends StatefulWidget {
  final _Notebook notebook;
  final VoidCallback onBack;
  const _NotebookDetail({required this.notebook, required this.onBack});

  @override
  State<_NotebookDetail> createState() => _NotebookDetailState();
}

class _ChatMsg {
  final String text;
  final bool fromUser;
  _ChatMsg(this.text, this.fromUser);
}

class _NotebookDetailState extends State<_NotebookDetail> {
  final _ai = AiService();
  final _chatCtrl = TextEditingController();
  final List<_ChatMsg> _messages = [];
  bool _sending = false;

  Future<void> _send() async {
    final text = _chatCtrl.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() {
      _messages.add(_ChatMsg(text, true));
      _chatCtrl.clear();
      _sending = true;
    });
    try {
      final reply = await _ai.sendMessage(
        message: text,
        mode: 'notebook',
        history: const [],
      );
      setState(() => _messages.add(_ChatMsg(reply, false)));
    } catch (e) {
      setState(() => _messages.add(_ChatMsg('Sorry, I couldn\'t reach the AI service.', false)));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 20, 8),
            child: Row(
              children: [
                IconButton(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
                Expanded(
                  child: Text(widget.notebook.name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                      overflow: TextOverflow.ellipsis),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary)),
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                for (final s in widget.notebook.sources)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Chip(
                      label: Text(s, style: const TextStyle(fontSize: 11)),
                      backgroundColor: AppColors.surfaceGlass,
                    ),
                  ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: const Text('Add source', style: TextStyle(fontSize: 11)),
                  onPressed: () => setState(() => widget.notebook.sources.add('New source.pdf')),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 20),
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Start by adding a source, then ask a question — the AI\nwill answer using only what\'s inside this notebook.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _messages.length,
                    itemBuilder: (context, i) {
                      final m = _messages[i];
                      return Align(
                        alignment: m.fromUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(maxWidth: 280),
                          decoration: BoxDecoration(
                            gradient: m.fromUser ? AppColors.aurora : null,
                            color: m.fromUser ? null : AppColors.surfaceGlass,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(m.text,
                              style: TextStyle(color: m.fromUser ? Colors.black : Colors.white)),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(hintText: 'Ask this notebook...'),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _sending ? null : _send,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _sending
                        ? const SizedBox(
                            key: ValueKey('loading'),
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.cyan))
                        : const Icon(Icons.send_rounded, key: ValueKey('idle'), color: AppColors.cyan),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
