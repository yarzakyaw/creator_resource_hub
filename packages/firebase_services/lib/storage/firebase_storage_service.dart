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
  }) async {
    final ref = _storage.ref(destinationPath);

    try {
      UploadTask uploadTask;

      if (kIsWeb && webBytes != null) {
        uploadTask = ref.putData(webBytes);
      } else if (localFile != null) {
        uploadTask = ref.putFile(localFile);
      } else {
        throw Exception('No file provided');
      }

      await uploadTask;
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }

  /* Future<String> uploadFile(File file, String destinationPath) async {
    final ref = _storage.ref(destinationPath);

    try {
      final uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() {});
      // Get the download URL after the upload is complete
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  } */
}
