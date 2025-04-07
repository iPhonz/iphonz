import 'comment.dart';
import 'user.dart';

class Post {
  final String id;
  final User user;
  final String content;
  final String? imageUrl; // Image for the post
  final int likes;
  final int comments;
  final int shares;
  final List<Comment> commentsList; // List of comments
  final bool? isJoined; // Whether the user has joined (optional)
  final DateTime timestamp;

  // Legacy properties (maintain backward compatibility)
  String get username => user.username;
  String get profileImage => user.profileImage;
  String? get memeImage => imageUrl;
  String? get tagline => user.bio;
  bool get hasJoined => isJoined ?? false;

  Post({
    required this.id,
    required this.user,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    this.shares = 0,
    this.commentsList = const [],
    this.isJoined,
    DateTime? timestamp,
  }) : this.timestamp = timestamp ?? DateTime.now();

  // Constructor to maintain backward compatibility
  factory Post.legacy({
    required String id,
    required String username,
    required String profileImage,
    required String content,
    String? memeImage,
    required int likes,
    required int comments,
    int shares = 0,
    String? tagline,
    List<Comment> commentsList = const [],
    bool hasJoined = false,
    DateTime? timestamp,
  }) {
    // Create a basic user using simplified constructor
    final user = User.basic(
      id: 'user_$id', // Generate a user ID based on post ID
      username: username.toLowerCase().replaceAll(' ', '_'),
      name: username,
      profileImage: profileImage,
      bio: tagline,
    );

    return Post(
      id: id, 
      user: user,
      content: content,
      imageUrl: memeImage,
      likes: likes,
      comments: comments,
      shares: shares,
      commentsList: commentsList,
      isJoined: hasJoined,
      timestamp: timestamp,
    );
  }

  // Create a copy of this post with updated values
  Post copyWith({
    String? id,
    User? user,
    String? content,
    String? imageUrl,
    int? likes,
    int? comments,
    int? shares,
    List<Comment>? commentsList,
    bool? isJoined,
    DateTime? timestamp,
  }) {
    return Post(
      id: id ?? this.id,
      user: user ?? this.user,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      commentsList: commentsList ?? this.commentsList,
      isJoined: isJoined ?? this.isJoined,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
