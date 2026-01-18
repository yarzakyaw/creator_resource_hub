import 'package:creator_resource_hub_mobile/features/resources/application/resource_providers.dart';
import 'package:firebase_services/resources/firestore_resource_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/resource.dart';

/// A widget to filter resources by type and category.
class ResourceFilters extends ConsumerStatefulWidget {
  const ResourceFilters({super.key});

  @override
  ConsumerState<ResourceFilters> createState() => _ResourceFiltersState();
}

class _ResourceFiltersState extends ConsumerState<ResourceFilters> {
  ResourceType? _selectedType;
  ResourceCategory? _selectedCategory;

  List<ResourceCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _selectedType = ref.read(resourceTypeFilterProvider);
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final collection = '${_selectedType?.name.toLowerCase() ?? ''}_categories';
    final firestoreService = FirestoreResourceService();
    final snapshot = await firestoreService.fetchAllCategories(collection);
    setState(() {
      _categories = snapshot;
      if (_categories.isNotEmpty) {
        _selectedCategory = _categories.first; // Default to the first category.
        ref.read(resourceCategoryFilterProvider.notifier).state =
            _selectedCategory?.name;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: DropdownButtonFormField<ResourceType>(
              initialValue: _selectedType,
              decoration: const InputDecoration(labelText: 'Type'),
              items: ResourceType.values
                  .map(
                    (type) =>
                        DropdownMenuItem(value: type, child: Text(type.name)),
                  )
                  .toList(),
              onChanged: (type) {
                ref.read(resourceTypeFilterProvider.notifier).state = type;
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
                ref.read(resourceCategoryFilterProvider.notifier).state =
                    category?.name;
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
