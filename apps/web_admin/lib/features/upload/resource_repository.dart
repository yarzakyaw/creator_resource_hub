import 'package:firebase_services/resources/firestore_resource_service.dart';
import 'package:models/resource.dart';

/// Repository to abstract Firestore access for resources.
class ResourceRepository {
  final FirestoreResourceService _resourceService;

  ResourceRepository({required FirestoreResourceService resourceService})
    : _resourceService = resourceService;

  /// Fetch all resources.
  Future<List<Resource>> fetchAllResources(String collection) =>
      _resourceService.fetchAllResources(collection);

  /// Fetch resources by type.
  Future<List<Resource>> fetchResourcesByType(ResourceType type) =>
      _resourceService.fetchResourcesByType(type);

  /// Fetch resources by category.
  Future<List<Resource>> fetchResourcesByCategory(
    String categoryId,
    String collection,
  ) => _resourceService.fetchResourcesByCategory(categoryId, collection);
}
