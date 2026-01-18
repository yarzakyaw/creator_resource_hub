import 'package:firebase_services/auth/auth_providers.dart';
import 'package:flutter/material.dart';
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
                if (user == null) {
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
            child: const Text('Close'),
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
        return _AudioPreview(url: resource.previewUrl);
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
class _AudioPreview extends StatefulWidget {
  final String url;

  const _AudioPreview({required this.url});

  @override
  State<_AudioPreview> createState() => _AudioPreviewState();
}

class _AudioPreviewState extends State<_AudioPreview> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            setState(() {
              isPlaying = !isPlaying;
            });
            // TODO: Implement audio play/pause logic.
          },
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
