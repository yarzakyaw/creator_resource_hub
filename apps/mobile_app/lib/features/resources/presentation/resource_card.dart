import 'package:flutter/material.dart';
import 'package:models/resource.dart';
import 'resource_detail_screen.dart';

/// A widget to display a single resource.
class ResourceCard extends StatelessWidget {
  final Resource resource;

  const ResourceCard({super.key, required this.resource});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: resource.isPremium
            ? const Icon(Icons.lock, color: Colors.amber)
            : const Icon(Icons.lock_open, color: Colors.green),
        title: Text(resource.title),
        subtitle: Text(resource.description),
        trailing: Text('${resource.fileSize} KB'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResourceDetailScreen(resource: resource),
            ),
          );
        },
      ),
    );
  }
}
