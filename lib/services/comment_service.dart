import 'dart:math';
import '../models/comment.dart';

class CommentService {
  // Singleton pattern
  static final CommentService _instance = CommentService._internal();
  factory CommentService() => _instance;
  CommentService._internal();

  // Random generator for IDs
  final Random _random = Random();

  // Generate a random ID
  String _generateId() {
    return 'comment_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(1000)}';
  }

  // Sample comments data
  final List<Comment> _sampleComments = [
    Comment(
      id: 'comment_1',
      username: 'solstice_soul',
      profileImage: 'assets/images/profile_solstice.jpg',
      content: 'That button probably has more clicks than my LinkedIn profile.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 14,
      replies: [],
    ),
    Comment(
      id: 'comment_2',
      username: 'mendacious_ninja_0',
      profileImage: 'assets/images/profile_mendacious.jpg',
      content: 'Someone at Netflix was like, \'Yeah, we paid \$1.5 million for this opening sequence, but honestly, who cares?\'',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      likes: 14,
      hasImage: true,
      imageUrl: 'assets/images/comment_meme.jpg',
      replies: [],
    ),
    Comment(
      id: 'comment_3',
      username: 'gustatory_dancer_70',
      profileImage: 'assets/images/profile_gustatory.jpg',
      content: 'Imagine telling your grandkids you contributed to human evolution by inventing a button that says, \'Nah, I\'m good.\'',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      likes: 14,
      replies: [],
    ),
    Comment(
      id: 'comment_4',
      username: 'risible_silversmith_22',
      profileImage: 'assets/images/profile_risible.jpg',
      content: 'This is why I have trust issues with technology.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      likes: 8,
      replies: [],
    ),
  ];

  // Callbacks for comment updates
  List<Function()> _listeners = [];

  // Add a listener
  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  // Remove a listener
  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  // Notify all listeners
  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  // Get all comments for a post
  List<Comment> getCommentsForPost(String postId) {
    // In a real app, we would filter by postId
    // For now, just return the sample comments
    return _sampleComments;
  }

  // Add a new comment to a post
  Comment addComment({
    required String postId,
    required String username,
    required String profileImage,
    required String content,
    String? imageUrl,
  }) {
    final newComment = Comment(
      id: _generateId(),
      username: username,
      profileImage: profileImage,
      content: content,
      timestamp: DateTime.now(),
      hasImage: imageUrl != null,
      imageUrl: imageUrl,
      replies: [],
    );

    _sampleComments.add(newComment);
    _notifyListeners();
    
    return newComment;
  }

  // Add a reply to a comment
  Comment addReply({
    required String commentId,
    required String username,
    required String profileImage,
    required String content,
    String? imageUrl,
  }) {
    final newReply = Comment(
      id: _generateId(),
      username: username,
      profileImage: profileImage,
      content: content,
      timestamp: DateTime.now(),
      hasImage: imageUrl != null,
      imageUrl: imageUrl,
      replies: [],
    );

    // Find the parent comment
    final parentCommentIndex = _sampleComments.indexWhere((comment) => comment.id == commentId);
    
    if (parentCommentIndex != -1) {
      // Add the reply to the parent comment
      final parentComment = _sampleComments[parentCommentIndex];
      final updatedReplies = List<Comment>.from(parentComment.replies)..add(newReply);
      
      // Update the parent comment
      _sampleComments[parentCommentIndex] = parentComment.copyWith(
        replies: updatedReplies,
      );
      
      _notifyListeners();
    }
    
    return newReply;
  }

  // Like a comment
  void likeComment(String commentId) {
    // Find the comment
    final commentIndex = _sampleComments.indexWhere((comment) => comment.id == commentId);
    
    if (commentIndex != -1) {
      // Update the comment with increased likes
      final comment = _sampleComments[commentIndex];
      _sampleComments[commentIndex] = comment.copyWith(
        likes: comment.likes + 1,
      );
      
      _notifyListeners();
    }
  }

  // Like a reply
  void likeReply(String parentCommentId, String replyId) {
    // Find the parent comment
    final parentCommentIndex = _sampleComments.indexWhere(
      (comment) => comment.id == parentCommentId
    );
    
    if (parentCommentIndex != -1) {
      final parentComment = _sampleComments[parentCommentIndex];
      
      // Find the reply
      final replyIndex = parentComment.replies.indexWhere(
        (reply) => reply.id == replyId
      );
      
      if (replyIndex != -1) {
        // Update the reply with increased likes
        final reply = parentComment.replies[replyIndex];
        final updatedReplies = List<Comment>.from(parentComment.replies);
        updatedReplies[replyIndex] = reply.copyWith(
          likes: reply.likes + 1,
        );
        
        // Update the parent comment
        _sampleComments[parentCommentIndex] = parentComment.copyWith(
          replies: updatedReplies,
        );
        
        _notifyListeners();
      }
    }
  }
}