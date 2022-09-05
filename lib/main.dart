import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:post_app_demo/firebase_options.dart';
import 'package:post_app_demo/pages/posts/posts_page.dart';
/*
Created by Axmadjon Isaqov on 16:20:32 05.09.2022
© 2022 @axi_dev 
*/

/*
Mavzu:::Post App
*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PostsPage(),
    );
  }
}
