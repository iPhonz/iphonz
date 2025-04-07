class Post {
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

  Post({
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
  });
}

class Comment {
  final String username;
  final String profileImage;
  final String content;

  Comment({
    required this.username,
    required this.profileImage,
    required this.content,
  });
}