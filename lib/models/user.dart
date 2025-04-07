class User {
  final String id;
  final String username;
  final String displayName;
  final String handle;
  final String pronouns;
  final String location;
  final String website;
  final String bio;
  final String profileImage;
  final String bannerImage;
  final List<String> interests;
  final List<String> followers;
  final List<String> following;
  final List<String> postIds;
  final List<String> groups;
  final bool isVerified;
  final String joinDate;
  final String userTag;
  final bool allowsMessages;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.handle,
    this.pronouns = '',
    this.location = '',
    this.website = '',
    this.bio = '',
    required this.profileImage,
    this.bannerImage = '',
    this.interests = const [],
    this.followers = const [],
    this.following = const [],
    this.postIds = const [],
    this.groups = const [],
    this.isVerified = false,
    required this.joinDate,
    this.userTag = '',
    this.allowsMessages = true,
  });

  // Create a copy of the user with updated fields
  User copyWith({
    String? id,
    String? username,
    String? displayName,
    String? handle,
    String? pronouns,
    String? location,
    String? website,
    String? bio,
    String? profileImage,
    String? bannerImage,
    List<String>? interests,
    List<String>? followers,
    List<String>? following,
    List<String>? postIds,
    List<String>? groups,
    bool? isVerified,
    String? joinDate,
    String? userTag,
    bool? allowsMessages,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      handle: handle ?? this.handle,
      pronouns: pronouns ?? this.pronouns,
      location: location ?? this.location,
      website: website ?? this.website,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      bannerImage: bannerImage ?? this.bannerImage,
      interests: interests ?? this.interests,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      postIds: postIds ?? this.postIds,
      groups: groups ?? this.groups,
      isVerified: isVerified ?? this.isVerified,
      joinDate: joinDate ?? this.joinDate,
      userTag: userTag ?? this.userTag,
      allowsMessages: allowsMessages ?? this.allowsMessages,
    );
  }

  // Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'handle': handle,
      'pronouns': pronouns,
      'location': location,
      'website': website,
      'bio': bio,
      'profileImage': profileImage,
      'bannerImage': bannerImage,
      'interests': interests,
      'followers': followers,
      'following': following,
      'postIds': postIds,
      'groups': groups,
      'isVerified': isVerified,
      'joinDate': joinDate,
      'userTag': userTag,
      'allowsMessages': allowsMessages,
    };
  }

  // Create from map for storage retrieval
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      displayName: map['displayName'],
      handle: map['handle'],
      pronouns: map['pronouns'] ?? '',
      location: map['location'] ?? '',
      website: map['website'] ?? '',
      bio: map['bio'] ?? '',
      profileImage: map['profileImage'],
      bannerImage: map['bannerImage'] ?? '',
      interests: List<String>.from(map['interests'] ?? []),
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      postIds: List<String>.from(map['postIds'] ?? []),
      groups: List<String>.from(map['groups'] ?? []),
      isVerified: map['isVerified'] ?? false,
      joinDate: map['joinDate'],
      userTag: map['userTag'] ?? '',
      allowsMessages: map['allowsMessages'] ?? true,
    );
  }
}