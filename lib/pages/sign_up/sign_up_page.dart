import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_app_demo/model/user_model.dart';
import 'package:post_app_demo/pages/sign_in/widgets/custom_field.dart';
import 'package:post_app_demo/service/fire_auth_src/fire_auth_src.dart';
import 'package:post_app_demo/service/firestore_src/cloud_firestore_src.dart';
import 'package:post_app_demo/service/prefs/prefs.dart';
import 'package:post_app_demo/util/logger.dart';
import 'package:post_app_demo/utils/app_route_src.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _authSrc = AuthEmailService(FirebaseAuth.instance);
  final _nameController = TextEditingController();
  final _prefs = Prefs();
  final _firestoreSrc = FireStoreService(FirebaseFirestore.instance);

  void _signUp() async {
    String? email = _emailController.text;
    String? password = _passwordController.text;
    String? confirmPassword = _confirmController.text;
    FocusScope.of(context).unfocus();
    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        _nameController.text.isEmpty) return;
    if (password != confirmPassword) return;
    try {
      UserCredential? userCredential =
          await _authSrc.createUser(email: email, password: password);

      await _prefs.saveData(key: 'uid', data: userCredential!.user!.uid);
      await _prefs.saveData(key: 'name', data: _nameController.text);

      UserModel? user = UserModel(
          createdAt: DateTime.now().toString(),
          name: _nameController.text,
          uid: userCredential.user!.uid);
      await _firestoreSrc.createCollectionData(collection: 'users', user: user);
      Log.log(userCredential.additionalUserInfo!.username);
      Consts.keyMessanger!.currentState!.showSnackBar(
          const SnackBar(content: Text('User tizimda qayd etildi')));
      setState(() {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(MyAppRouter.postPage, (route) => false);
      });
    } catch (e) {
      Log.log(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Sign Up',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextfield(
                controller: _nameController,
                placeholder: 'name',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextfield(
                controller: _emailController,
                placeholder: 'email',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextfield(
                controller: _passwordController,
                obscureText: true,
                placeholder: 'password',
                textInputAction: TextInputAction.done,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextfield(
                controller: _confirmController,
                obscureText: true,
                placeholder: 'confirm password',
                textInputAction: TextInputAction.done,
              ),
            ),
            CupertinoButton.filled(
                onPressed: _signUp, child: const Text('Sign Up')),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Mobodo akkaunting bolsa?'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('shu yerga bos'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
