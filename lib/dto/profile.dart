class Profile {
  final String name;
  final String id;
  final String profile;
  final String profileImg;
  final List<String> tags;

  Profile(this.name, this.id, this.profile, this.profileImg, this.tags);

  factory Profile.fromSnapshot(String id, Map<String, dynamic> document) {
    return Profile(
      document["name"].toString() ?? '',
      document["id"].toString() ?? '',
      document["profile"].toString() ?? '',
      document["profileImg"].toString() ?? '',
      (document["tags"] as List<dynamic>?)
              ?.map((tag) => tag.toString())
              .toList() ??
          <String>[],
    );
  }
}
