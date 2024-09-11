import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modelyprac/components/profileDetails.dart';
import 'package:modelyprac/components/profileTop.dart';

import '../core/providers.dart';
import '../dto/profile.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late FirebaseFirestore firestore;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    final user = ref.read(userProvider); // userをinitStateで取得
    if (!ref.read(profileProvider.notifier).hasProfile() && user != null) {
      _fetchProfile(user.uid);
    }
  }

  Future<void> _fetchProfile(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          ref
              .read(profileProvider.notifier)
              .setProfile(Profile.fromSnapshot(uid, data));
        });
      } else {
        print("Document does not exist");
        setState(() {});
      }
    } catch (e) {
      print("Error getting profile: $e");
      setState(() {});
    }
  }

  var expansionTitles = ["プロフィール", "経歴", "1日の過ごし方", "相談する"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !ref.read(profileProvider.notifier).hasProfile()
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: ProfileTop(profile: ref.watch(profileProvider)!),
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
