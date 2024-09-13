import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dto/profile.dart';

class ProfileNotifier extends Notifier<Profile?> {
  @override
  Profile? build() {
    return null;
  }

  void setProfile(Profile? profile) {
    state = profile;
  }

  void init() {
    state = Profile();
  }

  void setName(String name) {
    state?.name = name;
  }

  void setId(String id) {
    state?.id = id;
  }

  // いけてなさすぎる
  void setProfileText(String profile) {
    state?.profile = profile;
  }

  void setProfileImg(String profileImg) {
    state?.profileImg = profileImg;
  }

  void setTags(List<String> tags) {
    state?.tags = tags;
  }

  bool hasProfile() {
    return state != null;
  }

  void clearProfile() {
    state = null;
  }
}

final profileProvider =
    NotifierProvider<ProfileNotifier, Profile?>(ProfileNotifier.new);

class OtherUsersNotifier extends Notifier<List<Profile?>> {
  @override
  List<Profile> build() {
    return [];
  }

  void setProfiles(List<Profile> profiles) {
    state = profiles;
  }

  void clearProfiles() {
    state = [];
  }
}

final otherUsersProvider = NotifierProvider<OtherUsersNotifier, List<Profile?>>(
    OtherUsersNotifier.new);

class UserNotifier extends Notifier<User?> {
  @override
  User? build() {
    var auth = ref.read(firebaseAuthProvider);
    return auth.currentUser;
  }

  // ログイン時にユーザーをセット
  void setUser(User? user) {
    state = user;
  }

  // ログアウト時などにユーザーを削除
  void clearUser() {
    state = null;
  }
}

// StateNotifierProviderでUserを管理
final userProvider = NotifierProvider<UserNotifier, User?>(UserNotifier.new);

class EmailNotifier extends Notifier<String> {
  @override
  String build() {
    return "";
  }

  void setEmail(String email) {
    state = email;
  }
}

final emailProvider =
    NotifierProvider<EmailNotifier, String>(EmailNotifier.new);

class PasswordNotifier extends Notifier<String> {
  @override
  String build() {
    return "";
  }

  void setPassword(String password) {
    state = password;
  }
}

final passwordProvider =
    NotifierProvider<PasswordNotifier, String>(PasswordNotifier.new);

class ProfileImageNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    final user = ref.read(userProvider);
    if (user != null) {
      final Reference reference =
          FirebaseStorage.instance.ref().child("profiles/${user.uid}");
      String imageUrl = await reference.getDownloadURL();
      return imageUrl;
    }
    return "";
  }

  Future<void> uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profiles/${imageFile.path.split('/').last}');
      await storageRef.putFile(imageFile); // Cloud Storageに画像をアップロード
      final downloadUrl = await storageRef.getDownloadURL(); // ダウンロードURLを取得
      state = AsyncValue.data(downloadUrl);
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void set(String imageUrl) async {
    state = AsyncValue.data(imageUrl);
  }

  void clear() {
    state = const AsyncValue.data("");
  }
}

final profileImageProvider =
    AsyncNotifierProvider<ProfileImageNotifier, String>(
        ProfileImageNotifier.new);

class FireStoreNotifier extends Notifier<FirebaseFirestore> {
  @override
  FirebaseFirestore build() {
    return FirebaseFirestore.instance;
  }
}

final fireStoreProvider =
    NotifierProvider<FireStoreNotifier, FirebaseFirestore>(
        FireStoreNotifier.new);

class FirebaseAuthNotifier extends Notifier<FirebaseAuth> {
  @override
  FirebaseAuth build() {
    return FirebaseAuth.instance;
  }
}

final firebaseAuthProvider =
    NotifierProvider<FirebaseAuthNotifier, FirebaseAuth>(
        FirebaseAuthNotifier.new);
