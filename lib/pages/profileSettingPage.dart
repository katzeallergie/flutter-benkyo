import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modelyprac/core/providers.dart';
import 'package:modelyprac/pages/TagSettingPage.dart';

final List<Map<String, String>> settings = [
  {"name": "name", "display": "名前"},
  {"name": "id", "display": "ID"},
  {"name": "profile", "display": "自己紹介"},
  {"name": "profileImg", "display": "プロフィール画像のURL"},
];

class ProfileSettingPage extends ConsumerStatefulWidget {
  const ProfileSettingPage({super.key, required this.index});

  final int index;

  @override
  ConsumerState<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends ConsumerState<ProfileSettingPage> {
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var currentItem = settings[widget.index];
    var name = currentItem["name"];
    var displayName = currentItem["display"];
    return Scaffold(
      appBar: AppBar(
        title: const Text("MODELY", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 80),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            controller: controller,
            cursorColor: Color.fromRGBO(198, 99, 89, 1),
            decoration: InputDecoration(
                labelText: displayName,
                labelStyle: const TextStyle(color: Colors.grey),
                hintText: name == "profileImg"
                    ? "画像URLを入力してください"
                    : "$displayNameを入力してください",
                hintStyle: const TextStyle(color: Colors.grey),
                focusedBorder: const UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(198, 99, 89, 1)))),
            keyboardType: name == "profile"
                ? TextInputType.multiline
                : TextInputType.text,
            maxLines: name == "profile" ? null : 1,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                switch (name) {
                  case "name":
                    ref.read(profileProvider.notifier).init();
                    ref.read(profileProvider.notifier).setName(controller.text);
                    break;
                  case "id":
                    ref.read(profileProvider.notifier).setId(controller.text);
                    break;
                  case "profile":
                    ref
                        .read(profileProvider.notifier)
                        .setProfileText(controller.text);
                    break;
                  case "profileImg":
                    ref
                        .read(profileProvider.notifier)
                        .setProfileImg(controller.text);
                    break;
                  default:
                    break;
                }

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return widget.index < settings.length - 1
                      ? ProfileSettingPage(
                          index: widget.index + 1,
                        )
                      : const TagSettingPage();
                }));
              },
              child: const Text(
                "次へ",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(198, 99, 89, 1))),
        ]),
      ),
    );
  }
}
