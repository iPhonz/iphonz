import 'comment.dart';

class Post {
  final String id;
  final String username;
  final String profileImage;
  final String content;
  final String? memeImage; // Optional meme image
  final int likes;
  final int comments;
  final int shares;
  final String? tagline; // "All we do is skaaaate"
  final List<Comment> commentsList; // List of comments
  final bool hasJoined; // Whether the user has joined
  final DateTime timestamp;

  Post({
    required this.id,
    required this.username,
    required this.profileImage,
    required this.content,
    this.memeImage,
    required this.likes,
    required this.comments,
    required this.shares,
    this.tagline,
    this.commentsList = const [],
    this.hasJoined = false,
    DateTime? timestamp,
  }) : this.timestamp = timestamp ?? DateTime.now();

  // Create a copy of this post with updated values
  Post copyWith({
    String? id,
    String? username,
    String? profileImage,
    String? content,
    String? memeImage,
    int? likes,
    int? comments,
    int? shares,
    String? tagline,
    List<Comment>? commentsList,
    bool? hasJoined,
    DateTime? timestamp,
  }) {
    return Post(
      id: id ?? this.id,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      content: content ?? this.content,
      memeImage: memeImage ?? this.memeImage,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      tagline: tagline ?? this.tagline,
      commentsList: commentsList ?? this.commentsList,
      hasJoined: hasJoined ?? this.hasJoined,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}