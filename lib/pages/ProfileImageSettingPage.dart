import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modelyprac/core/providers.dart';
import 'package:modelyprac/pages/TagSettingPage.dart';

class ProfileImageSettingPage extends ConsumerStatefulWidget {
  const ProfileImageSettingPage({super.key});

  @override
  ConsumerState<ProfileImageSettingPage> createState() =>
      _ProfileImageSettingPageState();
}

class _ProfileImageSettingPageState
    extends ConsumerState<ProfileImageSettingPage> {
  @override
  Widget build(BuildContext context) {
    Future set() async {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        ref.read(profileImageProvider.notifier).set(image.path);
      }
    }

    final profileImageUrl = ref.watch(profileImageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("MODELY", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Stack(children: [
            Transform.scale(
                scale: 1,
                child: CircleAvatar(
                    radius: 80,
                    backgroundImage: profileImageUrl.when(data: (imageUrl) {
                      return imageUrl.isNotEmpty
                          ? FileImage(File(imageUrl))
                          : const AssetImage("assets/dummy.png");
                    }, error: (err, stack) {
                      const AssetImage("assets/dummy.png");
                      return null;
                    }, loading: () {
                      const AssetImage("assets/dummy.png");
                      return null;
                    }))),
            Positioned(
              top: -10,
              right: -10,
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  set();
                },
              ),
            ),
          ]),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const TagSettingPage();
                }));
              },
              child: const Text(
                "次へ",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(198, 99, 89, 1))),
        ]),
      ),
    );
  }
}
