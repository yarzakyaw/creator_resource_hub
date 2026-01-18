import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:models/resource.dart';

/// A service to handle Firestore operations for resources.
class FirestoreResourceService {
  final FirebaseFirestore _firestore;

  FirestoreResourceService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetch all resources.
  Future<List<Resource>> fetchAllResources(String collection) async {
    final snapshot = await _firestore.collection(collection).get();
    return snapshot.docs.map((doc) => Resource.fromFirestore(doc)).toList();
  }

  /// Fetch all resource categories.
  Future<List<ResourceCategory>> fetchAllCategories(String collection) async {
    final snapshot = await _firestore.collection(collection).get();
    /* return snapshot.docs
        .map((doc) => ResourceCategory.fromFirestore(doc))
        .toList(); */
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ResourceCategory.fromFirestore({
        'id': doc.id, // Include the document ID explicitly.
        ...data, // Spread the map to include all other fields.
      });
    }).toList();
  }

  /// Fetch resources by type.
  Future<List<Resource>> fetchResourcesByType(ResourceType type) async {
    final collection = '${type.name.toLowerCase()}_resources';
    final snapshot = await _firestore
        .collection(collection)
        .where('type', isEqualTo: type.name)
        .get();
    return snapshot.docs.map((doc) => Resource.fromFirestore(doc)).toList();
  }

  /// Fetch resources by category.
  Future<List<Resource>> fetchResourcesByCategory(
    String categoryId,
    String collection,
  ) async {
    final snapshot = await _firestore
        .collection(collection)
        .where('category.name', isEqualTo: categoryId)
        .get();
    return snapshot.docs.map((doc) => Resource.fromFirestore(doc)).toList();
  }

  /// Adds a new resource to Firestore.
  Future<void> addResource(Resource resource, String collection) async {
    try {
      final docRef = _firestore.collection(collection).doc();
      final id = docRef.id;
      await docRef.set({...resource.toFirestore(), 'id': id});
      // final resourceWithId = resource.copyWith(id: docRef.id);
      // await docRef.set(resourceWithId.toFirestore());
    } catch (e) {
      throw Exception('Failed to add resource: $e');
    }
  }

  /// Adds a new resource category to Firestore.
  Future<void> addResourceCategory(
    ResourceCategory category,
    String collection,
  ) async {
    try {
      final docRef = _firestore.collection(collection).doc(category.id);
      await docRef.set(category.toFirestore());
    } catch (e) {
      throw Exception('Failed to add resource category: $e');
    }
  }
}
