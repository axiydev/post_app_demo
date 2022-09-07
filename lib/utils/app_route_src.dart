import 'package:flutter/material.dart';

class MyAppRouter {
  static const signIn = '/sign_in';
  static const signUp = '/sign_up';
  static const createPost = '/create_post';
  static const postPage = '/post';
}

class Consts {
  static GlobalKey<ScaffoldMessengerState>? keyMessanger =
      GlobalKey<ScaffoldMessengerState>();
}
