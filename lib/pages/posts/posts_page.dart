import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:post_app_demo/model/post_model.dart';
import 'package:post_app_demo/pages/create_post/create_post_page.dart';
import 'package:post_app_demo/service/firestore_src/cloud_firestore_src.dart';
import 'package:post_app_demo/service/prefs/prefs.dart';
import 'package:post_app_demo/service/storage_src/cld_storage.dart';
import 'package:post_app_demo/util/logger.dart';
import 'package:post_app_demo/utils/app_route_src.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final _firestoreService = FireStoreService(FirebaseFirestore.instance);
  final _storageService = CloudStorageSrc(FirebaseStorage.instance);
  final _prefs = Prefs();
  String? _uid = '';

  @override
  void initState() {
    getUid();
    super.initState();
  }

  getUid() async {
    final prefLocal = await _prefs.getData(key: 'uid');
    Log.log(prefLocal);
    _uid = prefLocal;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('posts'),
        actions: [
          IconButton(
              onPressed: () async {
                final isLoggedIn = await _prefs.deleteData(key: 'uid');
                if (isLoggedIn) {
                  Consts.keyMessanger!.currentState!.showSnackBar(
                      const SnackBar(content: Text('Logout succesfully')));
                  setState(() {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        MyAppRouter.signIn, (route) => false);
                  });
                }
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FirestoreListView(
            shrinkWrap: true,
            errorBuilder: (ctx, error, stackTrace) => const Center(
                  child: CupertinoActivityIndicator(),
                ),
            loadingBuilder: (ctx) =>
                const Center(child: CupertinoActivityIndicator()),
            query: _firestoreService.firestore!
                .collection('posts')
                .orderBy('createdDate', descending: false),
            itemBuilder: (ctx, snapshot) {
              final post =
                  PostModel.fromJson(jsonDecode(json.encode(snapshot.data())));
              Log.log(snapshot.id);
              Log.log(_uid);
              return Card(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    dense: true,
                    title: Text(post.username!),
                    subtitle: Text(post.description!),
                    trailing: post.userId == _uid && _uid != ''
                        ? IconButton(
                            onPressed: () async {
                              await _firestoreService.removePost(
                                  post, snapshot.id);
                              await _storageService.removeImage(post);
                            },
                            icon: const Icon(Icons.delete),
                          )
                        : null,
                  ),
                  InteractiveViewer(
                    child: CachedNetworkImage(
                      imageUrl: post.imageUrl!,
                      height: 200,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                  )
                ],
              ));
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => const CreatePostPage()));
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
