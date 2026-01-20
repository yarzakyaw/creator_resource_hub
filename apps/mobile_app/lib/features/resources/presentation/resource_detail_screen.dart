import 'dart:async';

import 'package:core/services/audio_service.dart';
import 'package:creator_resource_hub_mobile/features/auth/login_screen.dart';
import 'package:firebase_services/auth/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:models/resource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../download/download_service.dart';

/// A screen to display detailed information about a resource.
class ResourceDetailScreen extends ConsumerWidget {
  final Resource resource;

  const ResourceDetailScreen({super.key, required this.resource});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(resource.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (resource.isPremium)
              const Chip(label: Text('Premium'), backgroundColor: Colors.amber),
            const SizedBox(height: 8),
            Text(
              'Type: ${resource.type.name}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Category: ${resource.category.name}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Expanded(child: _ResourcePreview(resource: resource)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final user = ref.read(currentUserProvider);
                if (user == null || user.isAnonymous) {
                  _showLoginPrompt(context);
                  return;
                }

                if (resource.isPremium) {
                  _showTelegramCTA(context);
                  return;
                }

                final downloadService = DownloadService();
                await downloadService.downloadResource(
                  resource.downloadUrl,
                  '${resource.title}.file',
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Download complete!')),
                );
              },
              child: const Text('Download'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('Please log in to download this resource.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              ); // Navigate to LoginScreen
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _showTelegramCTA(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Resource'),
        content: const Text(
          'This is a premium resource. Join our Telegram channel for access.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Replace with your Telegram link.
              launchUrl(Uri.parse('https://t.me/your_channel'));
            },
            child: const Text('Join Telegram'),
          ),
        ],
      ),
    );
  }
}

/// A widget to preview a resource based on its type.
class _ResourcePreview extends StatelessWidget {
  final Resource resource;

  const _ResourcePreview({required this.resource});

  @override
  Widget build(BuildContext context) {
    switch (resource.type) {
      case ResourceType.soundEffect:
      case ResourceType.voiceClip:
        return AudioPreview(url: resource.previewUrl);
      case ResourceType.image:
      case ResourceType.meme:
        return _ImagePreview(url: resource.previewUrl);
      default:
        return const Center(
          child: Text('Preview not available for this resource type.'),
        );
    }
  }
}

/// A widget to preview audio resources.
class AudioPreview extends StatefulWidget {
  final String url;

  const AudioPreview({required this.url, super.key});

  @override
  State<AudioPreview> createState() => _AudioPreviewState();
}

class _AudioPreviewState extends State<AudioPreview> {
  final audio = AudioService.instance;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audio.init();

    audio.player.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        isPlaying = state.playing;
      });
    });

    audio.player.processingStateStream.listen((state) {
      if (!mounted) return;
      if (state == ProcessingState.completed) {
        audio.stop();
        audio.player.seek(Duration.zero);
        setState(() => isPlaying = false);
      }
    });
  }

  Future<void> _toggle() async {
    if (isPlaying) {
      await audio.pause();
    } else {
      await audio.load(widget.url);
      await audio.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: _toggle,
        ),
        Text(isPlaying ? 'Playing...' : 'Paused'),
      ],
    );
  }
}

/// A widget to preview image resources.
class _ImagePreview extends StatelessWidget {
  final String url;

  const _ImagePreview({required this.url});

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.network(url, fit: BoxFit.contain));
  }
}
