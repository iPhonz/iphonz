import '../models/post.dart';

class PostService {
  // Singleton pattern
  static final PostService _instance = PostService._internal();
  factory PostService() => _instance;
  PostService._internal();

  // In-memory posts storage
  final List<Post> _posts = [
    Post(
      username: 'wanderlust_gypsy',
      profileImage: 'assets/images/profile1.jpg',
      content: "Me: 'I'm going to bed #earlytonight.' Also me at 3 AM: watching a raccoon wash grapes in slow motion",
      memeImage: 'assets/images/thinking_meme.jpg',
      likes: 16,
      comments: 0,
      shares: 0,
      tagline: 'All we do is skaaaate',
      hasJoined: true,
      commentsList: [
        Comment(
          username: 'mendacious_ninja_0',
          profileImage: 'assets/images/profile3.jpg',
          content: 'One thing about Black folks: we gon' laugh through the...',
        ),
      ],
    ),
    Post(
      username: 'wanderlust_gypsy',
      profileImage: 'assets/images/profile1.jpg',
      content: 'Sometimes it just makes more sense to just rest. #inmybag #skateboarding',
      likes: 16,
      comments: 0,
      shares: 0,
      tagline: 'All we do is skaaaate',
      hasJoined: false,
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

  // Create a new post
  void createPost({
    required String username,
    required String profileImage,
    required String content,
    String? memeImage,
    String? tagline,
  }) {
    final newPost = Post(
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
      final updatedPost = Post(
        username: post.username,
        profileImage: post.profileImage,
        content: post.content,
        memeImage: post.memeImage,
        likes: post.likes + 1,
        comments: post.comments,
        shares: post.shares,
        tagline: post.tagline,
        hasJoined: post.hasJoined,
        commentsList: post.commentsList,
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
      
      final updatedPost = Post(
        username: post.username,
        profileImage: post.profileImage,
        content: post.content,
        memeImage: post.memeImage,
        likes: post.likes,
        comments: post.comments + 1,
        shares: post.shares,
        tagline: post.tagline,
        hasJoined: post.hasJoined,
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
      final updatedPost = Post(
        username: post.username,
        profileImage: post.profileImage,
        content: post.content,
        memeImage: post.memeImage,
        likes: post.likes,
        comments: post.comments,
        shares: post.shares,
        tagline: post.tagline,
        hasJoined: !post.hasJoined,
        commentsList: post.commentsList,
      );
      
      _posts[index] = updatedPost;
      _notifyListeners();
    }
  }
}