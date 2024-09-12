import 'package:firebase_auth/firebase_auth.dart';
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
    return FirebaseAuth.instance.currentUser;
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
