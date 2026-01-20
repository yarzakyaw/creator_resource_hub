import 'dart:io';
import 'dart:typed_data';

import 'package:creator_resource_hub_admin/features/upload/resource_providers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_services/storage/firebase_storage_service.dart';
import 'package:firebase_services/resources/firestore_resource_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/resource.dart';

/// A screen to upload a new resource.
class UploadResourceScreen extends ConsumerStatefulWidget {
  const UploadResourceScreen({super.key});

  @override
  ConsumerState<UploadResourceScreen> createState() =>
      _UploadResourceScreenState();
}

class _UploadResourceScreenState extends ConsumerState<UploadResourceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  ResourceCategory? _selectedCategory;

  bool _isPremium = false;
  Uint8List? _webFileBytes;
  String? _fileName;
  File? _localFile;
  bool _isLoading = false;

  List<ResourceCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final collection =
        '${ref.read(resourceTypeFilterProvider)?.name.toLowerCase() ?? ''}_categories';
    final firestoreService = FirestoreResourceService();
    final snapshot = await firestoreService.fetchAllCategories(collection);
    setState(() {
      _categories = snapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Resource')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value?.isEmpty == true ? 'Required' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value?.isEmpty == true ? 'Required' : null,
              ),
              DropdownButtonFormField<ResourceType>(
                initialValue: ref.read(resourceTypeFilterProvider),
                decoration: const InputDecoration(labelText: 'Type'),
                items: ResourceType.values
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type.name)),
                    )
                    .toList(),
                onChanged: (type) {
                  ref.read(resourceTypeFilterProvider.notifier).state = type;
                  _fetchCategories();
                },
                validator: (value) => value == null ? 'Required' : null,
              ),
              ElevatedButton(
                onPressed: () => _showAddCategoryDialog(context),
                child: const Text('Add Category'),
              ),
              DropdownButtonFormField<ResourceCategory>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
                onChanged: (category) =>
                    setState(() => _selectedCategory = category),
                validator: (value) => value == null ? 'Required' : null,
              ),
              SwitchListTile(
                title: const Text('Premium'),
                value: _isPremium,
                onChanged: (value) => setState(() => _isPremium = value),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    withData: true, // REQUIRED for web
                  );
                  if (result == null) return;
                  setState(() {
                    _fileName = result.files.single.name;
                    if (kIsWeb) {
                      _webFileBytes = result.files.single.bytes;
                    } else {
                      _localFile = File(result.files.single.path!);
                    }
                  });
                },
                child: const Text('Select File'),
              ),
              if (_fileName != null) Text('Selected: $_fileName'),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _uploadResource,
                  child: const Text('Upload'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddCategoryDialog(BuildContext context) async {
    final categoryNameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Resource Category'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: categoryNameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
              validator: (value) => value?.isEmpty == true ? 'Required' : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final firestoreService = FirestoreResourceService();
                  final newCategory = ResourceCategory(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: categoryNameController.text,
                  );
                  final collection =
                      '${ref.read(resourceTypeFilterProvider)?.name.toLowerCase() ?? ''}_categories';

                  try {
                    await firestoreService.addResourceCategory(
                      newCategory,
                      collection,
                    );
                    setState(() {
                      _categories.add(newCategory);
                      _selectedCategory = newCategory;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Category added successfully!'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadResource() async {
    if (!_formKey.currentState!.validate() || _fileName == null) return;

    setState(() => _isLoading = true);

    final collection =
        '${ref.read(resourceTypeFilterProvider)?.name.toLowerCase() ?? ''}_resources';

    try {
      final storageService = FirebaseStorageService();
      final firestoreService = FirestoreResourceService();

      final fileUrl = await storageService.uploadFile(
        webBytes: _webFileBytes,
        localFile: _localFile,
        destinationPath: '$collection/$_fileName',
        isAudio:
            ref.read(resourceTypeFilterProvider) == ResourceType.soundEffect ||
            ref.read(resourceTypeFilterProvider) == ResourceType.voiceClip,
      );

      final fileSize = kIsWeb
          ? _webFileBytes!.length
          : _localFile!.lengthSync();

      final resource = Resource(
        id: '',
        title: _titleController.text,
        description: _descriptionController.text,
        type: ref.read(resourceTypeFilterProvider)!,
        category: _selectedCategory!,
        tags: [],
        isPremium: _isPremium,
        previewUrl: fileUrl,
        downloadUrl: fileUrl,
        fileSize: fileSize,
        createdAt: DateTime.now(),
        createdBy: 'admin', // Replace with actual admin user ID.
      );

      await firestoreService.addResource(resource, collection);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resource uploaded successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
