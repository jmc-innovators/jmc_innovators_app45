import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class _Video {
  final String title;
  final String youtubeId;
  const _Video(this.title, this.youtubeId);
}

/// Embedded YouTube player + category/search/history as specified.
/// youtubeId values are placeholders — replace with your channel's
/// real video IDs (e.g. from the "Watch Intro" playlist already linked
/// on the website).
class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});
  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  static const _videos = [
    _Video('Intro to JMC Innovators', 'dQw4w9WgXcQ'),
    _Video('Grade 10 Science Overview', 'dQw4w9WgXcQ'),
  ];
  YoutubePlayerController? _controller;

  void _play(_Video v) {
    _controller?.dispose();
    _controller = YoutubePlayerController(
      initialVideoId: v.youtubeId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Educational Videos')),
      body: Column(
        children: [
          if (_controller != null)
            YoutubePlayer(controller: _controller!, showVideoProgressIndicator: true),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _videos.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassCard(
                  onTap: () => _play(_videos[i]),
                  child: Row(
                    children: [
                      const Icon(Icons.play_circle_fill_rounded, color: AppColors.cyan, size: 32),
                      const SizedBox(width: 12),
                      Expanded(child: Text(_videos[i].title, style: const TextStyle(color: Colors.white))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
