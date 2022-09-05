import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class CloudStorageSrcRepository {
  final FirebaseStorage? _storage;
  const CloudStorageSrcRepository(this._storage);
  Future<String?> uploadImage(File? file);
  FirebaseStorage? get storage;
}

class CloudStorageSrc extends CloudStorageSrcRepository {
  const CloudStorageSrc(super._storage);
  @override
  FirebaseStorage? get storage => _storage;

  @override
  Future<String?> uploadImage(File? file) async {
    try {
      String? nameImage = 'image${DateTime.now()}';
      Reference ref = _storage!.ref();
      Reference subRef = ref.child('image_folder').child(nameImage);
      UploadTask task = subRef.putFile(file!);
      TaskSnapshot? snapshotTask = await task;
      final String downloadUrl = await snapshotTask.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException {
      rethrow;
    }
  }
}
