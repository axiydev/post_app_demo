import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:post_app_demo/model/post_model.dart';
import 'package:post_app_demo/util/logger.dart';

abstract class CloudStorageSrcRepository {
  final FirebaseStorage? _storage;
  const CloudStorageSrcRepository(this._storage);
  Future<String?> uploadImage(File? file, String? nameImage);
  Future<void> removeImage(PostModel post);
  FirebaseStorage? get storage;
}

class CloudStorageSrc extends CloudStorageSrcRepository {
  const CloudStorageSrc(super._storage);
  @override
  FirebaseStorage? get storage => _storage;

  @override
  Future<String?> uploadImage(File? file, String? nameImage) async {
    try {
      Reference ref = _storage!.ref();
      Reference subRef = ref.child('image_folder').child(nameImage!);
      UploadTask task = subRef.putFile(file!);
      TaskSnapshot? snapshotTask = await task;
      final String downloadUrl = await snapshotTask.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<void> removeImage(PostModel post) async {
    try {
      Reference ref = _storage!.ref();
      Reference newRef = ref.child('image_folder/${post.imageName!}');
      Log.log(newRef.name);
      return newRef.delete();
    } catch (e) {}
  }
}
