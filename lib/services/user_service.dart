import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserService extends ChangeNotifier {
  // Singleton pattern for user service
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal() {
    // Initialize with current user
    init();
  }

  // Current user
  late User _currentUser;
  
  // Map to track following relationships (userId -> isFollowing)
  final Map<String, bool> _followingRelationships = {};
  
  // Mock user data
  final Map<String, User> _users = {
    'user1': User(
      id: 'user1',
      username: 'pastaleoiancha',
      displayName: 'Leslie Alexander',
      profileImage: 'assets/images/user_profile.jpg',
      bio: '🌱 Cultivating life & beauty 🌸 | Lover of organic gardens, artful moments, and creativity in bloom. ✨ Let\'s grow together!',
      followers: 325,
      following: 182,
      handle: '@pastaleoiancha',
      pronouns: 'he/him',
      location: 'Los Angeles, CA',
      website: 'mywebsite.com',
      bannerImage: 'assets/images/user_banner.jpg',
      interests: ['Music', 'Pop Culture', 'Politics', 'Beyonce'],
      postIds: ['post1', 'post3', 'post5'],
      groups: ['VBrooks', 'SWright', 'BHill22', 'JRiver', 'MMartinez', 'RLewis'],
      isVerified: false,
      joinDate: DateTime(2023, 4, 15),
      userTag: '',
      allowsMessages: true,
    ),
    'user2': User(
      id: 'user2',
      username: 'keelyj',
      displayName: 'Keely Jones',
      profileImage: 'assets/images/user2_profile.jpg',
      bio: 'Living my best life ✨',
      followers: 1240,
      following: 567,
      handle: '@keelyjones',
      joinDate: DateTime(2024, 1, 7),
      postIds: ['post2', 'post4'],
      allowsMessages: true,
    ),
    'user3': User(
      id: 'user3',
      username: 'marcusd',
      displayName: 'Marcus Davis',
      profileImage: 'assets/images/user3_profile.jpg',
      bio: 'Music producer 🎵 | Travel enthusiast ✈️',
      followers: 5230,
      following: 328,
      handle: '@marcusd',
      joinDate: DateTime(2024, 2, 12),
      isVerified: true,
      allowsMessages: true,
    ),
  };

  // Initialize with current user
  void init() {
    _currentUser = _users['user1']!;
    
    // Initialize following relationships
    _followingRelationships['user2'] = true; // Assume current user follows user2
    _followingRelationships['user3'] = false; // Assume current user doesn't follow user3
  }

  // Get current user
  User get currentUser => _currentUser;
  
  // Get current user ID - added for messaging feature
  String? getCurrentUserId() {
    return _currentUser.id;
  }
  
  // Get all users - added for messaging feature
  Future<List<User>> getAllUsers() async {
    // In a real app, you'd fetch from a server or database
    return _users.values.toList();
  }

  // Get a user by ID
  User? getUserById(String userId) {
    return _users[userId];
  }

  // Check if current user is following another user
  bool isFollowing(String userId) {
    return _followingRelationships[userId] ?? false;
  }

  // Get user's followers (mock implementation)
  List<User> getCurrentUserFollowers() {
    // In a real app, we'd fetch actual followers by ID
    // For now, just return a sample of other users
    return _users.values.where((user) => user.id != _currentUser.id).take(2).toList();
  }

  // Get user's following (mock implementation)
  List<User> getCurrentUserFollowing() {
    // In a real app, we'd fetch actual following by ID
    // For now, just return a sample of other users
    return _users.values.where((user) => user.id != _currentUser.id).take(3).toList();
  }

  // Follow a user (mock implementation)
  void followUser(String userId) {
    if (_users.containsKey(userId)) {
      // Increment follower count of target user
      final targetUser = _users[userId]!;
      _users[userId] = targetUser.copyWith(
        followers: targetUser.followers + 1,
      );
      
      // Increment following count of current user
      _currentUser = _currentUser.copyWith(
        following: _currentUser.following + 1,
      );
      
      // Update the current user in the map
      _users[_currentUser.id] = _currentUser;
      
      // Update following relationship
      _followingRelationships[userId] = true;
      
      notifyListeners();
    }
  }

  // Unfollow a user (mock implementation)
  void unfollowUser(String userId) {
    if (_users.containsKey(userId)) {
      // Decrement follower count of target user
      final targetUser = _users[userId]!;
      if (targetUser.followers > 0) {
        _users[userId] = targetUser.copyWith(
          followers: targetUser.followers - 1,
        );
      }
      
      // Decrement following count of current user
      if (_currentUser.following > 0) {
        _currentUser = _currentUser.copyWith(
          following: _currentUser.following - 1,
        );
      }
      
      // Update the current user in the map
      _users[_currentUser.id] = _currentUser;
      
      // Update following relationship
      _followingRelationships[userId] = false;
      
      notifyListeners();
    }
  }

  // Update current user profile
  void updateProfile({
    String? displayName,
    String? handle,
    String? bio,
    String? location,
    String? website,
    String? pronouns,
    List<String>? interests,
    String? profileImage,
    String? bannerImage,
    bool? allowsMessages,
  }) {
    _currentUser = _currentUser.copyWith(
      displayName: displayName,
      handle: handle,
      bio: bio,
      location: location,
      website: website,
      pronouns: pronouns,
      interests: interests,
      profileImage: profileImage,
      bannerImage: bannerImage,
      allowsMessages: allowsMessages,
    );
    
    // Update in the user map
    _users[_currentUser.id] = _currentUser;
    
    notifyListeners();
  }

  // Add a post to current user
  void addPost(String postId) {
    final updatedPosts = List<String>.from(_currentUser.postIds)..add(postId);
    _currentUser = _currentUser.copyWith(postIds: updatedPosts);
    _users[_currentUser.id] = _currentUser;
    notifyListeners();
  }

  // Get users in a group (mock implementation)
  List<User> getUsersInGroup(String groupName) {
    // In a real app, we'd filter by actual group membership
    // For now, return a sample of users
    return _users.values.take(2).toList();
  }
}