import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../providers/userProvider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final String email = '';
  final String password = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    Future<void> register(context) async {
      try {
        var result = await auth.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        ref.read(userProvider.notifier).setUser(result.user);
        await Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return MyHomePage(title: 'MODELY', user: result.user!);
        }));
      } catch (e) {
        print(e);
        // 登録失敗
      }
    }

    Future<void> login(context) async {
      try {
        var result = await auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        ref.read(userProvider.notifier).setUser(result.user);
        await Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return MyHomePage(title: 'MODELY', user: result.user!);
        }));
      } catch (e) {
        print("loginerror");
        print(e);
        // ログイン失敗
      }
    }

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
                onPressed: () {
                  register(context);
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, double.infinity)),
                child: const Text("登録"),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    login(context);
                  },
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
