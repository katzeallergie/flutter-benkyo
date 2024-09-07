import 'package:flutter/material.dart';

// TODO: componentsに分けたりする
// TODO: プロフィールをfirebaseから取ってくる
// TODO: 状態管理にriverpodを使ってみる

void main() {
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
      home: const MyHomePage(title: 'MODELY'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Text("Home"),
    Text("検索"),
    Text("お気に入り"),
    Text("トーク"),
    MainPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
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
        selectedItemColor: Color.fromRGBO(187, 150, 132, 1),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.white,
        backgroundColor: const Color.fromRGBO(198, 99, 89, 1),
        onTap: _onItemTapped,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var profile = Profile(
      "牧田 隆",
      "@makkie2525",
      "10歳の子供がいます。子育てしながら執行役員として働いています。\n※新規事業立ち上げメンバー募集中",
      "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh-Y7rgTcW5NdDkxvwMW4Gdj2Q3G3lZVBvHHC10A3T_Iwxj0257NbTbdhvWKFOqn7nxXw6-V4P_0VFuJZ_5cQSDPxlazFKTD9N-d1A0IrX0k7LoaVpG3X9IwQ48H0zfXTJOT1JntRr0Lq3o/s1048/onepiece01_luffy.png",
      ["執行役員", "管理職", "マーケティング", "年収1500万", "関東", "子供一人"]);
  var expansionTitles = ["プロフィール", "経歴", "1日の過ごし方", "相談する"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: ProfilePage(profile: profile),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                top: 10,
              ),
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ProfileDetails(title: expansionTitles[index]);
                  },
                  itemCount: expansionTitles.length),
            ),
          )
        ],
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.profile});

  final Profile profile;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        children: [
                          const Icon(
                            Icons.bookmark,
                            color: Color.fromARGB(255, 219, 172, 52),
                          ),
                          Text(widget.profile.name)
                        ],
                      ),
                      subtitle: Text(widget.profile.id),
                    ),
                    Text(
                      widget.profile.profile,
                      style: const TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Image.network(
                  widget.profile.profileImg,
                  width: 150,
                  height: 150,
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 4,
            ),
            child: Wrap(
              spacing: 4,
              children: widget.profile.tags
                  .map((tag) => Chip(
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        side: BorderSide.none,
                        label: Text(tag),
                        backgroundColor: Colors.green,
                        labelStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ))
                  .toList(),
            ),
          ),
        ]);
  }
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedBackgroundColor: const Color.fromARGB(255, 236, 225, 218),
      backgroundColor: const Color.fromARGB(255, 236, 225, 218),
      shape: const RoundedRectangleBorder(
          side: BorderSide(
              color: Color.fromARGB(255, 121, 117, 116), width: 0.5)),
      collapsedShape: const RoundedRectangleBorder(
        side: BorderSide(color: Color.fromARGB(255, 121, 117, 116), width: 0.5),
      ),
      title: Text(
        title,
        style: const TextStyle(
            color: Color.fromARGB(255, 121, 117, 116),
            fontWeight: FontWeight.bold),
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.white,
          child: const Text(
              """業務では、仕様の決定から設計・実装・テストまで幅広く担当しています。\n業務で扱っている言語・フレームワークは経験の豊富な順に、Java、Spring Boot、Seasar2、Thymeleaf、Reactなどです。\nまた、PRJではオフショア開発を利用しており、実際にオフショア先に3ヶ月駐在し、現地メンバーをマネジメントした経験もあります。副業にて、チームで受託開発を行っており、案件募集しています。要件定義から実装、テスト、インフラの構築まで幅広くうけているためぜひご相談ください。"""),
        ) //TODO: 文章を可変にする
      ],
    );
  }
}

class Profile {
  final String name;
  final String id;
  final String profile;
  final String profileImg;
  final List<String> tags;

  Profile(this.name, this.id, this.profile, this.profileImg, this.tags);
}
