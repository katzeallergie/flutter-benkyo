import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modelyprac/pages/profileSettingPage.dart';

import '../core/providers.dart';
import '../main.dart';

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
  String errorText = "";
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isObscure = true;
  bool hasError = false;

  bool validation() {
    var email = emailController.text;
    var password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorText = "メールアドレスかパスワード入力されていません";
        hasError = true;
      });
      return hasError;
    }

    if (password.length < 6) {
      setState(() {
        errorText = "パスワードは6字以上で入力してください";
        hasError = true;
      });
      return hasError;
    }

    setState(() {
      hasError = false;
    });
    return hasError;
  }

  @override
  Widget build(BuildContext context) {
    void register(context) {
      ref.read(emailProvider.notifier).setEmail(emailController.text);
      ref.read(passwordProvider.notifier).setPassword(passwordController.text);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const ProfileSettingPage(index: 0);
      }));
    }

    Future<void> login(context) async {
      try {
        var result = await auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        ref.read(userProvider.notifier).setUser(result.user);
        await Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return const MyHomePage(title: 'MODELY');
        }));
      } catch (e) {
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
                cursorColor: const Color.fromRGBO(198, 99, 89, 1),
                decoration: const InputDecoration(
                    labelText: 'メールアドレス',
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(198, 99, 89, 1)))),
              ),
              TextField(
                controller: passwordController,
                cursorColor: const Color.fromRGBO(198, 99, 89, 1),
                decoration: InputDecoration(
                    labelText: 'パスワード',
                    hintText: "6文字以上のパスワード",
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                    labelStyle: const TextStyle(color: Colors.grey),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(198, 99, 89, 1)))),
                obscureText: isObscure,
              ),
              hasError
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        errorText,
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    )
                  : const SizedBox(
                      height: 40,
                    ),
              ElevatedButton(
                onPressed: () {
                  hasError = validation();
                  if (hasError) {
                    return;
                  }
                  register(context);
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, double.infinity),
                    backgroundColor: const Color.fromRGBO(198, 99, 89, 1)),
                child: const Text(
                  "新規登録",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    hasError = validation();
                    if (hasError) {
                      return;
                    }
                    login(context);
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(150, double.infinity),
                      backgroundColor: const Color.fromRGBO(198, 99, 89, 1)),
                  child: const Text(
                    "ログイン",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
