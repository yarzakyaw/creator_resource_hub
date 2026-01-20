import 'package:creator_resource_hub_admin/features/upload/resource_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/resource.dart';

/// A screen to edit resource metadata.
class ResourceEditScreen extends ConsumerStatefulWidget {
  final Resource resource;

  const ResourceEditScreen({super.key, required this.resource});

  @override
  ConsumerState<ResourceEditScreen> createState() => _ResourceEditScreenState();
}

class _ResourceEditScreenState extends ConsumerState<ResourceEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late bool _isPremium;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.resource.title);
    _descriptionController = TextEditingController(
      text: widget.resource.description,
    );
    _isPremium = widget.resource.isPremium;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Resource')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              SwitchListTile(
                title: const Text('Premium'),
                value: _isPremium,
                onChanged: (value) => setState(() => _isPremium = value),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final updatedResource = widget.resource.copyWith(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    isPremium: _isPremium,
                  );
                  await ref
                      .read(resourceRepositoryProvider)
                      .updateResource(updatedResource);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
