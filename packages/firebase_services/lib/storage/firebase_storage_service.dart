import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

/// A service to handle Firebase Storage operations.
class FirebaseStorageService {
  final FirebaseStorage _storage;

  FirebaseStorageService({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  /// Downloads a file from Firebase Storage.
  Future<File> downloadFile(String url, String localPath) async {
    final ref = _storage.refFromURL(url);
    final file = File(localPath);

    final downloadTask = ref.writeToFile(file);
    await downloadTask.whenComplete(() {});

    return file;
  }

  /// Uploads a file to Firebase Storage and returns its download URL.
  Future<String> uploadFile({
    Uint8List? webBytes,
    File? localFile,
    required String destinationPath,
    bool isAudio = false,
  }) async {
    final ref = _storage.ref(destinationPath);
    final metadata = isAudio
        ? SettableMetadata(contentType: 'audio/mpeg')
        : null;

    try {
      UploadTask uploadTask;

      if (kIsWeb && webBytes != null) {
        uploadTask = ref.putData(webBytes, metadata);
      } else if (localFile != null) {
        uploadTask = ref.putFile(localFile, metadata);
      } else {
        throw Exception('No file provided');
      }

      await uploadTask;
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }

  /// Deletes a file from Firebase Storage.
  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }
}
