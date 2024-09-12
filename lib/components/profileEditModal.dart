import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modelyprac/core/providers.dart';

import '../dto/profile.dart';

class ProfileEditModal extends ConsumerStatefulWidget {
  const ProfileEditModal({super.key});

  @override
  ConsumerState<ProfileEditModal> createState() => _ProfileEditModalState();
}

class _ProfileEditModalState extends ConsumerState<ProfileEditModal> {
  var nameController = TextEditingController();
  var profileController = TextEditingController();
  List<TextEditingController> tagsController = [];

  Future<void> save(String uid) async {
    var document = FirebaseFirestore.instance.collection("users").doc(uid);
    var tags = tagsController
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();
    await document.update({
      "name": nameController.text,
      "profile": profileController.text,
      "tags": tags
    });
    var snapshot = await document.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      ref
          .read(profileProvider.notifier)
          .setProfile(Profile.fromSnapshot(uid, data));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final profile = ref.watch(profileProvider);
    nameController.text = profile!.name;
    profileController.text = profile.profile;
    var tags = profile.tags;
    tagsController = List.generate(
        tags.length, (index) => TextEditingController(text: tags[index]));

    return Scaffold(
        appBar: AppBar(
          title: const Text("MODELY", style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
              child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    hintText: "Your name", labelText: "名前"),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: profileController,
                decoration: const InputDecoration(
                    hintText: "Your Profile", labelText: "自己紹介"),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (index != tags.length) {
                      return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: TextField(
                            decoration: InputDecoration(
                                labelText: index == 0 ? "タグ" : null),
                            controller: tagsController[index],
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  tags.removeAt(index);
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
                            tags.add("");
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
                  itemCount: tags.length + 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                    onPressed: () {
                      save(user!.uid);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(198, 99, 89, 1)),
                    child: const Text(
                      "保存する",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    )),
              )
            ],
          )),
        ));
  }
}
