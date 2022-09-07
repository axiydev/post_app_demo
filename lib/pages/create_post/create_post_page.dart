import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_app_demo/model/post_model.dart';
import 'package:post_app_demo/service/firestore_src/cloud_firestore_src.dart';
import 'package:post_app_demo/service/pick/img_pick.dart';
import 'package:post_app_demo/service/prefs/prefs.dart';
import 'package:post_app_demo/service/storage_src/cld_storage.dart';
import 'package:post_app_demo/util/logger.dart';
import 'package:uuid/uuid.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _description = TextEditingController();
  final PickService _pickService = PickService();
  final FireStoreService _fireStoreService =
      FireStoreService(FirebaseFirestore.instance);
  final CloudStorageSrc _cloudStorageSrc =
      CloudStorageSrc(FirebaseStorage.instance);
  final _prefs = Prefs();
  bool? _isLoading = false;
  io.File? _imageFile;

  ///upload file from galery to local storage
  Future<io.File?> uploadImageFromGalley() async {
    try {
      var file = await _pickService.getFileFromGallery();

      return io.File(file!.path);
    } catch (e) {
      Log.log(e);
    }
    return null;
  }

  ///upload file from camera to local storage
  Future<io.File?> uploadImageFromCamera() async {
    try {
      var file = await _pickService.getFileFromCamera();

      return io.File(file!.path);
    } catch (e) {
      Log.log(e);
    }
    return null;
  }

  ///upload data to Firestore and Cloud Storage
  Future<void> uploadDataToFirebase() async {
    try {
      _isLoading = true;
      FocusScope.of(context).unfocus();
      setState(() {});
      if (_description.text.isEmpty) return;
      final imageName = DateTime.now();
      final String? imageUrl =
          await _cloudStorageSrc.uploadImage(_imageFile, 'image$imageName');
      PostModel myPost = PostModel(
          imageUrl: imageUrl,
          createdDate: imageName.toString(),
          description: _description.text,
          id: const Uuid().v1(),
          userId: await _prefs.getData(key: 'uid'),
          username: await _prefs.getData(key: 'name'),
          imageName: 'image$imageName');
      Log.log(imageUrl);
      await _fireStoreService.createPost(myPost);
      _isLoading = false;
      setState(() {
        Navigator.of(context).pop();
      });
    } catch (e) {
      Log.log(e);
    }
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () async {
                            _imageFile = await uploadImageFromGalley();
                            setState(() {});
                          },
                          child: _imageFile == null
                              ? const Icon(
                                  CupertinoIcons.photo,
                                  size: 100,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(
                                    _imageFile!,
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                    cacheHeight: 200,
                                    cacheWidth: 200,
                                  ),
                                )),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () async {
                          _imageFile = await uploadImageFromCamera();
                          setState(() {});
                        },
                        child: const Icon(
                          CupertinoIcons.camera,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CupertinoTextField(
                    controller: _description,
                    textInputAction: TextInputAction.done,
                    placeholder: 'description',
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                        onPressed: uploadDataToFirebase,
                        child: const Text('upload')),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading!)
            Container(
              color: Colors.grey[300]!.withOpacity(0.5),
              child: const Center(
                child: SizedBox(
                    height: 50, width: 50, child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
