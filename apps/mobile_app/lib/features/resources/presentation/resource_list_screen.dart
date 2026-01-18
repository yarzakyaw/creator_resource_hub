import 'package:creator_resource_hub_mobile/features/resources/application/resource_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'resource_card.dart';
import 'resource_filters.dart';

/// A screen to display a list of resources.
class ResourceListScreen extends ConsumerWidget {
  const ResourceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourceCategory = ref.watch(resourceCategoryFilterProvider);
    final resourcesAsync = ref.watch(filteredResourcesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Resources')),
      body: Column(
        children: [
          const ResourceFilters(),
          Expanded(
            child: resourcesAsync.when(
              data: (resources) {
                // Filter resources by category if selected.
                final filteredResources = resourceCategory != null
                    ? resources
                          .where((r) => r.category.name == resourceCategory)
                          .toList()
                    : resources;
                return ListView.builder(
                  itemCount: filteredResources.length,
                  itemBuilder: (context, index) {
                    final resource = filteredResources[index];
                    return ResourceCard(resource: resource);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) {
                debugPrint('Error loading resources: $error');
                return Center(child: Text('Error: $error'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
