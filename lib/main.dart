import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modelyprac/firebase_options.dart';
import 'package:modelyprac/pages/HomePage.dart';
import 'package:modelyprac/pages/loginPage.dart';

import '../core/providers.dart';
import 'pages/ProfilePage.dart';

// TODO: ログイン情報が残ってたら、自動ログインしてホームに飛ばす
// TODO: アーキテクチャを意識してリファクタする
// TODO: 毎回色つけたりしているので、グローバルで色設定するように
// TODO: 空入力でも進めるようになっているので、バリデーションかける
// TODO: 他の人のプロフィールページに飛べるようにする
// TODO: 年収ごとにラベル分けできるように
// TODO: チャット機能

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme:
              const AppBarTheme(color: Color.fromRGBO(198, 99, 89, 1))),
      home: const LoginPage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const Text("検索"),
    const Text("お気に入り"),
    const Text("トーク"),
    const ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void showLogoutDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("ログアウトしますか？"),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "キャンセル",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  logout();
                },
                child: const Text(
                  "ログアウト",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          );
        });
  }

  Future<void> logout() async {
    var auth = ref.read(firebaseAuthProvider);
    await auth.signOut();
    ref.read(userProvider.notifier).clearUser();
    ref.read(profileProvider.notifier).clearProfile();
    ref.read(otherUsersProvider.notifier).clearProfiles();
    ref.read(profileImageProvider.notifier).clear();
    await Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) {
      return const LoginPage();
    }), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: showLogoutDialog, icon: const Icon(Icons.logout))
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "ホーム",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "検索"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: "お気に入り"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none), label: "トーク"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "マイページ"),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Color.fromRGBO(227, 163, 189, 1),
        selectedItemColor: const Color.fromRGBO(187, 150, 132, 1),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.white,
        backgroundColor: const Color.fromRGBO(198, 99, 89, 1),
        onTap: _onItemTapped,
      ),
    );
  }
}
