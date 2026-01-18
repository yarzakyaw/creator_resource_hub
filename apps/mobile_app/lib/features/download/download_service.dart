import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_services/storage/firebase_storage_service.dart';

/// A service to handle file downloads.
class DownloadService {
  final FirebaseStorageService _storageService;

  DownloadService({FirebaseStorageService? storageService})
    : _storageService = storageService ?? FirebaseStorageService();

  /// Downloads a file and saves it to the device.
  Future<File> downloadResource(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final localPath = '${directory.path}/$fileName';

    return _storageService.downloadFile(url, localPath);
  }
}
