import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modelyprac/core/providers.dart';

import '../main.dart';

class TagSettingPage extends ConsumerStatefulWidget {
  const TagSettingPage({super.key});

  @override
  ConsumerState<TagSettingPage> createState() => _TagSettingPageState();
}

class _TagSettingPageState extends ConsumerState<TagSettingPage> {
  List<TextEditingController> tagsController = [TextEditingController()];
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Future<void> register(context) async {
      var email = ref.read(emailProvider);
      var password = ref.read(passwordProvider);
      try {
        var result = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        ref.read(userProvider.notifier).setUser(result.user);
        var profileImgFileUrl = ref.read(profileImageProvider).value;
        await ref
            .read(profileImageProvider.notifier)
            .uploadImage(File(profileImgFileUrl!));
        var profileImgUrl = ref.read(profileImageProvider).value;
        ref.read(profileProvider.notifier).setProfileImg(profileImgUrl!);
        var profile = ref.read(profileProvider);
        var firestore = ref.read(fireStoreProvider);
        var collection = firestore.collection("users");
        collection.doc(result.user?.uid).set({
          "name": profile?.name,
          "id": profile?.id,
          "profile": profile?.profile,
          "profileImg": ref.read(profileImageProvider).value,
          "tags": profile?.tags
        });

        await Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return const MyHomePage(title: 'MODELY');
        }), (route) => false);
      } catch (e) {
        print(e);
        // 登録失敗
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("MODELY", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  if (index != tagsController.length) {
                    return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: TextField(
                          cursorColor: const Color.fromRGBO(198, 99, 89, 1),
                          decoration: InputDecoration(
                            labelText: index == 0 ? "タグ" : null,
                            labelStyle: const TextStyle(color: Colors.grey),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(198, 99, 89, 1))),
                          ),
                          controller: tagsController[index],
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                tagsController.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete)));
                  }
                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: EdgeInsets.zero,
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minHeight: 0, minWidth: 0),
                      onPressed: () {
                        setState(() {
                          tagsController.add(TextEditingController());
                        });
                        ref.read(profileProvider.notifier).setTags(
                            tagsController
                                .map((controller) => controller.text)
                                .toList());
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                itemCount: tagsController.length + 1,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  var tags = tagsController
                      .map((controller) => controller.text)
                      .where((text) => text.isNotEmpty)
                      .toList();
                  ref.read(profileProvider.notifier).setTags(tags);

                  register(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(198, 99, 89, 1)),
                child: const Text(
                  "作成する",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
