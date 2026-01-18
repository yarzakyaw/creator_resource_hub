import 'package:creator_resource_hub_admin/features/upload/resource_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_services/resources/firestore_resource_service.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:models/resource.dart';

/// Provider for FirestoreResourceService.
final firestoreResourceServiceProvider = Provider<FirestoreResourceService>((
  ref,
) {
  return FirestoreResourceService();
});

/// Provider for ResourceRepository.
final resourceRepositoryProvider = Provider<ResourceRepository>((ref) {
  final resourceService = ref.read(firestoreResourceServiceProvider);
  return ResourceRepository(resourceService: resourceService);
});

/// Provider for the list of all resources, with a configurable collection name.
final resourceListProvider = FutureProvider.family<List<Resource>, String>((
  ref,
  collection,
) {
  final repository = ref.read(resourceRepositoryProvider);
  return repository.fetchAllResources(collection);
});

/// Provider for filtering resources by type.
final resourceTypeFilterProvider = StateProvider<ResourceType?>(
  (ref) => ResourceType.soundEffect,
);

/// Provider for filtering resources by category.
final resourceCategoryFilterProvider = StateProvider<String?>((ref) => null);

final filteredResourcesProvider = FutureProvider.family<List<Resource>, String>(
  (ref, collection) {
    final repository = ref.read(resourceRepositoryProvider);
    final typeFilter = ref.watch(resourceTypeFilterProvider);
    final categoryFilter = ref.watch(resourceCategoryFilterProvider);

    if (typeFilter != null) {
      return repository.fetchResourcesByType(typeFilter);
    } else if (categoryFilter != null) {
      return repository.fetchResourcesByCategory(categoryFilter, collection);
    } else {
      return repository.fetchAllResources(collection);
    }
  },
);
