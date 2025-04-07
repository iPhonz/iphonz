class User {
  final String id;
  final String username;
  final String displayName;
  final String profileImage;
  final String? bio;
  final int followers;
  final int following;
  final bool isVerified;
  final DateTime? joinDate;
  
  // Additional properties
  final String handle;
  final String pronouns;
  final String location;
  final String website;
  final String bannerImage;
  final List<String> interests;
  final List<String> postIds;
  final List<String> groups;
  final String userTag;
  final bool allowsMessages;

  // Getter for compatibility with posts that expect 'name'
  String get name => displayName;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.profileImage,
    this.bio,
    required this.followers,
    required this.following,
    this.isVerified = false,
    this.joinDate,
    this.handle = '',
    this.pronouns = '',
    this.location = '',
    this.website = '',
    this.bannerImage = '',
    this.interests = const [],
    this.postIds = const [],
    this.groups = const [],
    this.userTag = '',
    this.allowsMessages = true,
  });

  // Simplified constructor for basic user creation
  factory User.basic({
    required String id,
    required String username,
    required String name,
    required String profileImage,
    String? bio,
  }) {
    return User(
      id: id,
      username: username,
      displayName: name,
      profileImage: profileImage,
      bio: bio,
      followers: 0,
      following: 0,
    );
  }

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
    DateTime? joinDate,
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
      followers: followers != null ? List<String>.from(followers) : this.followers,
      following: following != null ? List<String>.from(following) : this.following,
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
      'joinDate': joinDate?.toIso8601String(),
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
      handle: map['handle'] ?? '',
      pronouns: map['pronouns'] ?? '',
      location: map['location'] ?? '',
      website: map['website'] ?? '',
      bio: map['bio'],
      profileImage: map['profileImage'],
      bannerImage: map['bannerImage'] ?? '',
      interests: List<String>.from(map['interests'] ?? []),
      followers: map['followers'] is int ? map['followers'] : 0,
      following: map['following'] is int ? map['following'] : 0,
      postIds: List<String>.from(map['postIds'] ?? []),
      groups: List<String>.from(map['groups'] ?? []),
      isVerified: map['isVerified'] ?? false,
      joinDate: map['joinDate'] != null ? DateTime.parse(map['joinDate']) : null,
      userTag: map['userTag'] ?? '',
      allowsMessages: map['allowsMessages'] ?? true,
    );
  }
}
