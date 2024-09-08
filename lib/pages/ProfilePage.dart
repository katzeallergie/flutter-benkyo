import 'package:flutter/material.dart';
import 'package:modelyprac/components/profileDetails.dart';
import 'package:modelyprac/components/profileTop.dart';

import '../dto/profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            child: ProfileTop(profile: profile),
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
