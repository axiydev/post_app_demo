import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:post_app_demo/model/post_model.dart';
import 'package:post_app_demo/util/logger.dart';

abstract class CldFirestoreSrcRepository {
  final FirebaseFirestore? _firestore;
  const CldFirestoreSrcRepository(this._firestore);
  Future<void> createPost(PostModel? post);
  Future<void> removePost(PostModel? post, String? id);
  FirebaseFirestore? get firestore;
}

class FireStoreService extends CldFirestoreSrcRepository {
  const FireStoreService(FirebaseFirestore firestore) : super(firestore);
  @override
  Future<void> createPost(PostModel? post) async {
    try {
      final CollectionReference coll = _firestore!.collection('posts');
      await coll.add(post!.toJson());
    } on FirebaseException {
      Log.log('Firebase Exception');
    }
  }

  @override
  Future<void> removePost(PostModel? post, String? id) async {
    try {
      final CollectionReference<Map<String, dynamic>> coll =
          _firestore!.collection('posts');
      await coll.doc('$id').delete();
    } catch (e) {
      Log.log(e);
    }
  }

  @override
  FirebaseFirestore? get firestore => _firestore;
}
