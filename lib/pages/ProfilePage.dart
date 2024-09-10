import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modelyprac/components/profileDetails.dart';
import 'package:modelyprac/components/profileTop.dart';

import '../dto/profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.uid});

  final String uid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late FirebaseFirestore firestore;
  var _isLoading = true;
  late Profile profile;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    // Profileアクセスのたびに取得してるので、状態管理とかでいい感じにする
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          profile = Profile.fromSnapshot(widget.uid, data);
          _isLoading = false;
        });
      } else {
        print("Document does not exist");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error getting profile: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  var expansionTitles = ["プロフィール", "経歴", "1日の過ごし方", "相談する"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
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
