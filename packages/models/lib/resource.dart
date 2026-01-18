import 'package:cloud_firestore/cloud_firestore.dart';

/// Enum representing the type of a resource.
enum ResourceType { soundEffect, voiceClip, image, font, meme, other }

/// Model representing a resource category.
class ResourceCategory {
  final String id;
  final String name;

  ResourceCategory({required this.id, required this.name});

  /// Converts a Firestore document to a ResourceCategory.
  factory ResourceCategory.fromFirestore(Map<String, dynamic> data) {
    // final data = doc.data() as Map<String, dynamic>;
    // return ResourceCategory(id: doc.id, name: data['name'] as String);
    return ResourceCategory(
      id: data['id'] as String? ?? '',
      name: data['name'] as String? ?? 'Unknown',
    );
  }

  /// Converts a ResourceCategory to a Firestore-compatible map.
  Map<String, dynamic> toFirestore() {
    return {'name': name};
  }
}

/// Model representing a resource.
class Resource {
  final String id;
  final String title;
  final String description;
  final ResourceType type;
  final ResourceCategory category;
  final List<String> tags;
  final bool isPremium;
  final String previewUrl;
  final String downloadUrl;
  final int fileSize;
  final DateTime createdAt;
  final String createdBy;

  Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.tags,
    required this.isPremium,
    required this.previewUrl,
    required this.downloadUrl,
    required this.fileSize,
    required this.createdAt,
    required this.createdBy,
  });

  /// Converts a Firestore document to a Resource.
  factory Resource.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Resource(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String,
      type: ResourceType.values.byName(data['type'] as String),
      category: ResourceCategory.fromFirestore(
        data['category'] as Map<String, dynamic>? ?? {},
      ),
      tags: List<String>.from(data['tags'] as List),
      isPremium: data['isPremium'] as bool,
      previewUrl: data['previewUrl'] as String,
      downloadUrl: data['downloadUrl'] as String,
      fileSize: data['fileSize'] as int,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] as String,
    );
  }

  /// Converts a Resource to a Firestore-compatible map.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'type': type.name,
      'category': category.toFirestore(),
      'tags': tags,
      'isPremium': isPremium,
      'previewUrl': previewUrl,
      'downloadUrl': downloadUrl,
      'fileSize': fileSize,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }

  /// Creates a copy of the current Resource with updated fields.
  Resource copyWith({
    String? id,
    String? title,
    String? description,
    ResourceType? type,
    ResourceCategory? category,
    List<String>? tags,
    bool? isPremium,
    String? previewUrl,
    String? downloadUrl,
    int? fileSize,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return Resource(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isPremium: isPremium ?? this.isPremium,
      previewUrl: previewUrl ?? this.previewUrl,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
