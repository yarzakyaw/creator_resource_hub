import 'package:creator_resource_hub_admin/features/upload/resource_providers.dart';
import 'package:firebase_services/resources/firestore_resource_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/resource.dart';

import 'resource_delete_dialog.dart';
import 'resource_edit_screen.dart';

/// A screen to display a list of resources.
class ResourceListScreen extends ConsumerStatefulWidget {
  const ResourceListScreen({super.key});

  @override
  ConsumerState<ResourceListScreen> createState() => _ResourceListScreenState();
}

class _ResourceListScreenState extends ConsumerState<ResourceListScreen> {
  ResourceType? _selectedType;
  ResourceCategory? _selectedCategory;
  List<ResourceCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _selectedType = ResourceType.soundEffect; // Default type
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final collection = '${_selectedType?.name.toLowerCase() ?? ''}_categories';
    final firestoreService = FirestoreResourceService();
    final snapshot = await firestoreService.fetchAllCategories(collection);
    setState(() {
      _categories = snapshot;
      if (_categories.isNotEmpty) {
        _selectedCategory = _categories.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final resourcesAsync = ref.watch(
      filteredResourcesProvider(
        '${_selectedType?.name.toLowerCase()}_resources',
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Resources')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  child: DropdownButtonFormField<ResourceType>(
                    initialValue: _selectedType,
                    decoration: const InputDecoration(labelText: 'Type'),
                    items: ResourceType.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.name),
                          ),
                        )
                        .toList(),
                    onChanged: (type) {
                      setState(() {
                        _selectedType = type;
                        _fetchCategories();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: DropdownButtonFormField<ResourceCategory>(
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
                    onChanged: (category) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: resourcesAsync.when(
              data: (resources) {
                final filteredResources = _selectedCategory != null
                    ? resources
                          .where(
                            (r) => r.category.name == _selectedCategory?.name,
                          )
                          .toList()
                    : resources;

                // Refresh the filteredResources variable when the provider is invalidated
                ref.listen(
                  filteredResourcesProvider(
                    '${_selectedType?.name.toLowerCase()}_resources',
                  ),
                  (_, _) {
                    setState(() {});
                  },
                );

                return DataTable(
                  columns: const [
                    DataColumn(label: Text('Title')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: filteredResources.map((resource) {
                    return DataRow(
                      cells: [
                        DataCell(Text(resource.title)),
                        DataCell(Text(resource.type.name)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ResourceEditScreen(
                                        resource: resource,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final shouldDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => ResourceDeleteDialog(
                                      resource: resource,
                                    ),
                                  );
                                  if (shouldDelete == true) {
                                    ref
                                        .read(resourceRepositoryProvider)
                                        .deleteResource(resource)
                                        .then((_) {
                                          ref.invalidate(
                                            filteredResourcesProvider(
                                              '${_selectedType?.name.toLowerCase()}_resources',
                                            ),
                                          );
                                        });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
