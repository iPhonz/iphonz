import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserService extends ChangeNotifier {
  // Singleton pattern for user service
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  // Current user
  late User _currentUser;
  
  // Mock user data
  final Map<String, User> _users = {
    'user1': User(
      id: 'user1',
      username: 'pastaleoiancha',
      displayName: 'Leslie Alexander',
      handle: '@pastaleoiancha',
      pronouns: '(he/him)',
      location: 'Los Angeles, CA',
      website: 'mywebsite.com',
      bio: '🌱 Cultivating life & beauty 🌸 | Lover of organic gardens, artful moments, and creativity in bloom. ✨ Let\'s grow together!',
      profileImage: 'assets/images/user_profile.jpg',
      bannerImage: 'assets/images/user_banner.jpg',
      interests: ['Music', 'Pop Culture', 'Politics', 'Beyonce'],
      followers: ['user2', 'user3', 'user4'],
      following: ['user2', 'user5', 'user6'],
      postIds: ['post1', 'post3', 'post5'],
      groups: ['VBrooks', 'SWright', 'BHill22', 'JRiver', 'MMartinez', 'RLewis'],
      isVerified: false,
      joinDate: 'April 2023',
      allowsMessages: false,
    ),
    'user2': User(
      id: 'user2',
      username: 'keelyj',
      displayName: 'Keely Jones',
      handle: '@keelyjones',
      profileImage: 'assets/images/user2_profile.jpg',
      joinDate: 'January 2024',
      postIds: ['post2', 'post4'],
    ),
    'user3': User(
      id: 'user3',
      username: 'marcusd',
      displayName: 'Marcus Davis',
      handle: '@marcusd',
      profileImage: 'assets/images/user3_profile.jpg',
      joinDate: 'February 2024',
      isVerified: true,
    ),
  };

  // Initialize with current user
  void init() {
    _currentUser = _users['user1']!;
  }

  // Get current user
  User get currentUser => _currentUser;

  // Get a user by ID
  User? getUserById(String userId) {
    return _users[userId];
  }

  // Get user's followers
  List<User> getCurrentUserFollowers() {
    return _currentUser.followers
        .map((id) => _users[id])
        .whereType<User>()
        .toList();
  }

  // Get user's following
  List<User> getCurrentUserFollowing() {
    return _currentUser.following
        .map((id) => _users[id])
        .whereType<User>()
        .toList();
  }

  // Follow a user
  void followUser(String userId) {
    if (!_currentUser.following.contains(userId)) {
      final updatedFollowing = List<String>.from(_currentUser.following)
        ..add(userId);
      
      _currentUser = _currentUser.copyWith(following: updatedFollowing);
      
      // Update the target user's followers list
      if (_users.containsKey(userId)) {
        final targetUser = _users[userId]!;
        final updatedFollowers = List<String>.from(targetUser.followers)
          ..add(_currentUser.id);
        
        _users[userId] = targetUser.copyWith(followers: updatedFollowers);
      }
      
      notifyListeners();
    }
  }

  // Unfollow a user
  void unfollowUser(String userId) {
    if (_currentUser.following.contains(userId)) {
      final updatedFollowing = List<String>.from(_currentUser.following)
        ..remove(userId);
      
      _currentUser = _currentUser.copyWith(following: updatedFollowing);
      
      // Update the target user's followers list
      if (_users.containsKey(userId)) {
        final targetUser = _users[userId]!;
        final updatedFollowers = List<String>.from(targetUser.followers)
          ..remove(_currentUser.id);
        
        _users[userId] = targetUser.copyWith(followers: updatedFollowers);
      }
      
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

  // Get users in a group
  List<User> getUsersInGroup(String groupName) {
    return _users.values
        .where((user) => user.groups.contains(groupName))
        .toList();
  }
}