import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:post_app_demo/firebase_options.dart';
import 'package:post_app_demo/pages/create_post/create_post_page.dart';
import 'package:post_app_demo/pages/posts/posts_page.dart';
import 'package:post_app_demo/pages/sign_in/sign_in_page.dart';
import 'package:post_app_demo/pages/sign_up/sign_up_page.dart';
import 'package:post_app_demo/service/prefs/prefs.dart';
import 'package:post_app_demo/utils/app_route_src.dart';
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
    final prefs = Prefs();
    return FutureBuilder(
        future: prefs.getData(key: 'uid'),
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Flutter Demo',
            scaffoldMessengerKey: Consts.keyMessanger,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            routes: {
              MyAppRouter.signIn: (context) => const SignInPage(),
              MyAppRouter.signUp: (context) => const SignUpPage(),
              MyAppRouter.createPost: (context) => const CreatePostPage(),
              MyAppRouter.postPage: (context) => const PostsPage()
            },
            home:
                snapshot.data != null ? const PostsPage() : const SignInPage(),
          );
        });
  }
}
