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

  bool hasProfile() {
    return state != null;
  }

  void clearProfile() {
    state = null;
  }
}

final profileProvider =
    NotifierProvider<ProfileNotifier, Profile?>(ProfileNotifier.new);

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
