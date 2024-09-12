import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modelyprac/components/profileTop.dart';
import 'package:modelyprac/core/providers.dart';

import '../dto/profile.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    if (ref.read(otherUsersProvider).isEmpty) {
      _fetchUsers();
    }
    super.initState();
  }

  Future<void> _fetchUsers() async {
    var firestore = FirebaseFirestore.instance;
    var user = ref.read(userProvider);
    var querySnapshot = await firestore.collection("users").get();
    List<Profile> profiles =
        querySnapshot.docs.where((doc) => doc.id != user!.uid).map((doc) {
      var data = doc.data();
      return Profile.fromSnapshot(doc.id, data);
    }).toList();
    ref.read(otherUsersProvider.notifier).setProfiles(profiles);
  }

  @override
  Widget build(BuildContext context) {
    var profiles = ref.watch(otherUsersProvider);
    return profiles.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(24),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ProfileTop(profile: profiles[index]!);
              },
              itemCount: profiles.length,
            ),
          );
  }
}
