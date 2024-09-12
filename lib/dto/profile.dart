class Profile {
  String name;
  String id;
  String profile;
  String profileImg;
  List<String> tags;

  Profile()
      : name = '',
        id = '',
        profile = '',
        profileImg = '',
        tags = const <String>[];

  Profile.withArgs({
    required this.name,
    required this.id,
    required this.profile,
    required this.profileImg,
    required this.tags,
  });

  factory Profile.fromSnapshot(String id, Map<String, dynamic> document) {
    return Profile.withArgs(
      name: document["name"].toString() ?? '',
      id: document["id"].toString() ?? '',
      profile: document["profile"].toString() ?? '',
      profileImg: document["profileImg"].toString() ?? '',
      tags: (document["tags"] as List<dynamic>?)
              ?.map((tag) => tag.toString())
              .toList() ??
          <String>[],
    );
  }
}
