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
