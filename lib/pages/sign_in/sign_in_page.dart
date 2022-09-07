import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_app_demo/pages/sign_in/widgets/custom_field.dart';
import 'package:post_app_demo/service/fire_auth_src/fire_auth_src.dart';
import 'package:post_app_demo/service/prefs/prefs.dart';
import 'package:post_app_demo/util/logger.dart';
import 'package:post_app_demo/utils/app_route_src.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthEmailService(FirebaseAuth.instance);
  final _prefs = Prefs();

  void _signIn() async {
    String? email = _emailController.text;
    String? password = _passwordController.text;
    FocusScope.of(context).unfocus();
    if (email.isEmpty || password.isEmpty) return;
    try {
      final UserCredential? userCredential =
          await _authService.loginUser(email: email, password: password);
      User? userAuth = userCredential!.user;
      if (userAuth != null) {
        await _prefs.saveData(key: 'uid', data: userAuth.uid);
        Consts.keyMessanger!.currentState!
            .showSnackBar(const SnackBar(content: Text('Login')));
        setState(() {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(MyAppRouter.postPage, (route) => false);
        });
      }
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
              'Sign In',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
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
            CupertinoButton.filled(
                onPressed: _signIn, child: const Text('Login')),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Mobodo akkaunting bolmasa?'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(MyAppRouter.signUp);
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
