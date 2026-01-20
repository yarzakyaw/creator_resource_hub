import 'package:flutter/material.dart';
import 'package:models/resource.dart';
import 'resource_detail_screen.dart';

/// A widget to display a single resource.
class ResourceCard extends StatefulWidget {
  final Resource resource;

  const ResourceCard({super.key, required this.resource});

  @override
  State<ResourceCard> createState() => _ResourceCardState();
}

class _ResourceCardState extends State<ResourceCard> {
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: widget.resource.isPremium
            ? const Icon(Icons.lock, color: Colors.amber)
            : const Icon(Icons.lock_open, color: Colors.green),
        title: Text(widget.resource.title),
        subtitle: Text(widget.resource.description),
        trailing: Text('${widget.resource.fileSize} KB'),
        onTap: _isNavigating
            ? null
            : () async {
                setState(() => _isNavigating = true);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ResourceDetailScreen(resource: widget.resource),
                  ),
                );
                setState(() => _isNavigating = false);
              },
      ),
    );
  }
}
