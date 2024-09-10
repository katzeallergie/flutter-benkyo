import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final String email = '';
  final String password = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isObscure = true;

  Future<void> register() async {
    try {
      var result = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      await Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return MyHomePage(title: 'MODELY', user: result.user!);
      }));
    } catch (e) {
      // 登録失敗
    }
  }

  Future<void> login() async {
    try {
      var result = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      await Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return MyHomePage(title: 'MODELY', user: result.user!);
      }));
    } catch (e) {
      // ログイン失敗
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MODELY",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'メールアドレス'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: 'パスワード',
                    suffixIcon: IconButton(
                      icon: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    )),
                obscureText: isObscure,
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: register,
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, double.infinity)),
                child: const Text("登録"),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(150, double.infinity)),
                  child: const Text("ログイン")),
            ],
          ),
        ),
      ),
    );
  }
}
