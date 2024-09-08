import 'package:flutter/material.dart';

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
