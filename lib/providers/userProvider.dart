// StateNotifierを使ってユーザーの状態を管理
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
