import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modelyprac/firebase_options.dart';
import 'package:modelyprac/pages/loginPage.dart';

import 'pages/ProfilePage.dart';

// TODO: componentsに分けたりする
// TODO: プロフィールをfirebaseから取ってくる
// TODO: 状態管理にriverpodを使ってみる

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: AppBarTheme(color: Color.fromRGBO(198, 99, 89, 1))),
      home: const LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.user});

  final String title;
  final User user;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Text("user"),
    Text("検索"),
    Text("お気に入り"),
    Text("トーク"),
    ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) {
      return const LoginPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      body: Center(
        child: _selectedIndex == 0
            ? CheckLoginUser(email: widget.user.email!)
            : _widgetOptions.elementAt(_selectedIndex),
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
        selectedItemColor: Color.fromRGBO(187, 150, 132, 1),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.white,
        backgroundColor: const Color.fromRGBO(198, 99, 89, 1),
        onTap: _onItemTapped,
      ),
    );
  }
}

class CheckLoginUser extends StatefulWidget {
  const CheckLoginUser({super.key, required this.email});

  final String email;

  @override
  State<CheckLoginUser> createState() => _CheckLoginUserState();
}

class _CheckLoginUserState extends State<CheckLoginUser> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("${widget.email}\nでログインしてまする"),
    );
  }
}
