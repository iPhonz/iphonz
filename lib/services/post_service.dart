import 'dart:math';
import '../models/post.dart';
import '../models/comment.dart';

class PostService {
  // Singleton pattern
  static final PostService _instance = PostService._internal();
  factory PostService() => _instance;
  PostService._internal();

  // Random generator for IDs
  final Random _random = Random();

  // Generate a random ID
  String _generateId() {
    return 'post_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(1000)}';
  }

  // In-memory posts storage
  final List<Post> _posts = [
    Post(
      id: 'post_1',
      username: 'wanderlust_gypsy',
      profileImage: 'assets/images/profile1.jpg',
      content: "Me: 'I'm going to bed #earlytonight.' Also me at 3 AM: watching a raccoon wash grapes in slow motion",
      memeImage: 'assets/images/thinking_meme.jpg',
      likes: 16,
      comments: 0,
      shares: 4,
      tagline: 'All we do is skaaaate',
      hasJoined: true,
      commentsList: [],
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Post(
      id: 'post_2',
      username: 'wanderlust_gypsy',
      profileImage: 'assets/images/profile1.jpg',
      content: 'Sometimes it just makes more sense to just rest. #inmybag #skateboarding',
      likes: 16,
      comments: 0,
      shares: 0,
      tagline: 'All we do is skaaaate',
      hasJoined: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    ),
  ];

  // Callbacks for post updates
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

  // Get all posts
  List<Post> getPosts() {
    return List.unmodifiable(_posts);
  }

  // Get a post by ID
  Post? getPostById(String id) {
    try {
      return _posts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }

  // Create a new post
  void createPost({
    required String username,
    required String profileImage,
    required String content,
    String? memeImage,
    String? tagline,
  }) {
    final newPost = Post(
      id: _generateId(),
      username: username,
      profileImage: profileImage,
      content: content,
      memeImage: memeImage,
      likes: 0,
      comments: 0,
      shares: 0,
      tagline: tagline ?? 'All we do is skaaaate',
      hasJoined: true,
      commentsList: [],
      timestamp: DateTime.now(),
    );

    // Add to the beginning of the list
    _posts.insert(0, newPost);
    
    // Notify listeners
    _notifyListeners();
  }

  // Like a post
  void likePost(int index) {
    if (index >= 0 && index < _posts.length) {
      final post = _posts[index];
      final updatedPost = post.copyWith(
        likes: post.likes + 1,
      );
      
      _posts[index] = updatedPost;
      _notifyListeners();
    }
  }

  // Share a post
  void sharePost(int index) {
    if (index >= 0 && index < _posts.length) {
      final post = _posts[index];
      final updatedPost = post.copyWith(
        shares: post.shares + 1,
      );
      
      _posts[index] = updatedPost;
      _notifyListeners();
    }
  }

  // Add comment to a post
  void addComment(int postIndex, Comment comment) {
    if (postIndex >= 0 && postIndex < _posts.length) {
      final post = _posts[postIndex];
      final newCommentsList = List<Comment>.from(post.commentsList)..add(comment);
      
      final updatedPost = post.copyWith(
        comments: post.comments + 1,
        commentsList: newCommentsList,
      );
      
      _posts[postIndex] = updatedPost;
      _notifyListeners();
    }
  }

  // Toggle join status
  void toggleJoin(int index) {
    if (index >= 0 && index < _posts.length) {
      final post = _posts[index];
      final updatedPost = post.copyWith(
        hasJoined: !post.hasJoined,
      );
      
      _posts[index] = updatedPost;
      _notifyListeners();
    }
  }
}