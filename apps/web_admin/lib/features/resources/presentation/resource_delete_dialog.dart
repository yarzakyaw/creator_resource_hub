import 'package:flutter/material.dart';
import 'package:models/resource.dart';

/// A dialog to confirm resource deletion.
class ResourceDeleteDialog extends StatelessWidget {
  final Resource resource;

  const ResourceDeleteDialog({super.key, required this.resource});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Resource'),
      content: Text('Are you sure you want to delete "${resource.title}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
