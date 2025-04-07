class Post {
  final String username;
  final String profileImage;
  final String content;
  final int likes;
  final int comments;
  final int shares;

  Post({
    required this.username,
    required this.profileImage,
    required this.content,
    required this.likes,
    required this.comments,
    required this.shares,
  });
}