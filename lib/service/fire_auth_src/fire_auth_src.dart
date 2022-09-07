import 'package:firebase_auth/firebase_auth.dart';
import 'package:post_app_demo/util/logger.dart';

abstract class AuthRepository {
  final FirebaseAuth? auth;
  const AuthRepository({required this.auth});
  Future<UserCredential?> createUser(
      {required String? email, required String? password});
  Future<UserCredential?> loginUser(
      {required String? email, required String? password});
  Future<void> deleteUser();
}

class AuthEmailService extends AuthRepository {
  const AuthEmailService(FirebaseAuth auth) : super(auth: auth);
  @override
  Future<UserCredential?> createUser(
      {required String? email, required String? password}) async {
    try {
      final UserCredential userCredential = await auth!
          .createUserWithEmailAndPassword(email: email!, password: password!);
      return userCredential;
    } on FirebaseException {
      Log.log('You han an error');
      rethrow;
    }
  }

  @override
  Future<void> deleteUser() {
    try {
      return auth!.currentUser!.delete();
    } on FirebaseException {
      Log.log('You han an error');
      rethrow;
    }
  }

  @override
  Future<UserCredential?> loginUser(
      {required String? email, required String? password}) async {
    try {
      final UserCredential userCredential = await auth!
          .signInWithEmailAndPassword(email: email!, password: password!);
      return userCredential;
    } on FirebaseException {
      Log.log('You han an error');
      rethrow;
    }
  }
}
