class Comment {
  final String id;
  final String username;
  final String profileImage;
  final String content;
  final DateTime timestamp;
  final int likes;
  final bool hasImage;
  final String? imageUrl;
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.username,
    required this.profileImage,
    required this.content,
    required this.timestamp,
    this.likes = 0,
    this.hasImage = false,
    this.imageUrl,
    this.replies = const [],
  });

  // Create a copy of this comment with updated values
  Comment copyWith({
    String? id,
    String? username,
    String? profileImage,
    String? content,
    DateTime? timestamp,
    int? likes,
    bool? hasImage,
    String? imageUrl,
    List<Comment>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      hasImage: hasImage ?? this.hasImage,
      imageUrl: imageUrl ?? this.imageUrl,
      replies: replies ?? this.replies,
    );
  }
}