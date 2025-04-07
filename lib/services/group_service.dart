import 'package:flutter/foundation.dart';
import '../models/group.dart';
import '../models/user.dart';
import '../models/post.dart';
import 'user_service.dart';

class GroupService with ChangeNotifier {
  final List<Group> _groups = [];
  final List<Group> _joinedGroups = [];
  final UserService _userService = UserService();

  GroupService() {
    _initGroups();
  }

  List<Group> getGroups() {
    return List.unmodifiable(_groups);
  }

  List<Group> getJoinedGroups() {
    return _joinedGroups;
  }

  Group getGroupById(String id) {
    return _groups.firstWhere((group) => group.id == id);
  }

  List<Group> searchGroups(String query) {
    if (query.isEmpty) {
      return _groups;
    }
    
    return _groups.where((group) {
      return group.name.toLowerCase().contains(query.toLowerCase()) ||
             group.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<Group> filterByCategory(GroupCategory category) {
    return _groups.where((group) => group.category == category).toList();
  }

  void joinGroup(String groupId) {
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index != -1) {
      final Group group = _groups[index];
      if (!group.isJoined) {
        final updatedGroup = group.copyWith(
          isJoined: true,
          members: [...group.members, _userService.currentUser],
          memberCount: group.memberCount + 1,
        );
        
        _groups[index] = updatedGroup;
        _joinedGroups.add(updatedGroup);
        notifyListeners();
      }
    }
  }

  void leaveGroup(String groupId) {
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index != -1) {
      final Group group = _groups[index];
      if (group.isJoined) {
        final updatedGroup = group.copyWith(
          isJoined: false,
          members: group.members.where((user) => user.id != _userService.currentUser.id).toList(),
          memberCount: group.memberCount - 1,
        );
        
        _groups[index] = updatedGroup;
        _joinedGroups.removeWhere((g) => g.id == groupId);
        notifyListeners();
      }
    }
  }

  void toggleJoinGroup(String groupId) {
    final group = getGroupById(groupId);
    if (group.isJoined) {
      leaveGroup(groupId);
    } else {
      joinGroup(groupId);
    }
  }

  void createGroup({
    required String name,
    required String description,
    required String groupImage,
    required GroupCategory category,
  }) {
    final newGroup = Group(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      groupImage: groupImage,
      members: [_userService.currentUser],
      memberCount: 1,
      posts: [],
      newSpillsCount: 0,
      isJoined: true,
      category: category,
    );
    
    _groups.add(newGroup);
    _joinedGroups.add(newGroup);
    notifyListeners();
  }

  void addPostToGroup(String groupId, Post post) {
    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index != -1) {
      final group = _groups[index];
      final updatedGroup = group.copyWith(
        posts: [...group.posts, post],
        newSpillsCount: group.newSpillsCount + 1,
      );
      
      _groups[index] = updatedGroup;
      
      // Update in joined groups list if applicable
      final joinedIndex = _joinedGroups.indexWhere((g) => g.id == groupId);
      if (joinedIndex != -1) {
        _joinedGroups[joinedIndex] = updatedGroup;
      }
      
      notifyListeners();
    }
  }

  void _initGroups() {
    // Sample users for groups
    final users = [
      User(
        id: '1',
        username: 'j_smith',
        name: 'James Smith',
        bio: 'Coffee enthusiast, meme lover ☕',
        profileImage: 'assets/images/avatars/avatar1.png',
        followers: 1240,
        following: 420,
        isVerified: true,
        joinDate: DateTime(2023, 5, 12),
      ),
      User(
        id: '2',
        username: 'maria_g',
        name: 'Maria Garcia',
        bio: 'Travel junkie | Food critic',
        profileImage: 'assets/images/avatars/avatar2.png',
        followers: 3500,
        following: 750,
        isVerified: false,
        joinDate: DateTime(2023, 3, 25),
      ),
      User(
        id: '3',
        username: 'tech_dave',
        name: 'David Chen',
        bio: 'Tech enthusiast and gadget reviewer',
        profileImage: 'assets/images/avatars/avatar3.png',
        followers: 5200,
        following: 310,
        isVerified: true,
        joinDate: DateTime(2023, 1, 8),
      ),
    ];

    // Sample posts for groups
    final posts = [
      Post(
        id: '1',
        user: users[0],
        content: 'Just shared the latest track from @kendrick! 🔥 #HipHop #NewMusic',
        imageUrl: 'assets/images/posts/music_post.png',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        likes: 156,
        comments: 42,
        isJoined: true,
      ),
      Post(
        id: '2',
        user: users[1],
        content: 'What did everyone think of that plot twist in the season finale? #TVTalk',
        imageUrl: 'assets/images/posts/tv_post.png',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        likes: 89,
        comments: 76,
        isJoined: false,
      ),
      Post(
        id: '3',
        user: users[2],
        content: 'New yoga practice today was intense but worth it! #MondayMotivation',
        imageUrl: 'assets/images/posts/yoga_post.png',
        timestamp: DateTime.now().subtract(const Duration(hours: 24)),
        likes: 215,
        comments: 28,
        isJoined: true,
      ),
    ];

    // Create sample groups
    _groups.addAll([
      Group(
        id: '1',
        name: 'In My Bag',
        description: 'A group for sharing emotional moments and venting',
        groupImage: 'assets/images/groups/group1.png',
        members: [users[0], users[1], users[2]],
        memberCount: 126,
        posts: [posts[0], posts[1]],
        newSpillsCount: 2,
        category: GroupCategory.entertainment,
      ),
      Group(
        id: '2',
        name: 'Not Today Baby',
        description: 'For when you just can\'t deal with the nonsense',
        groupImage: 'assets/images/groups/group2.png',
        members: [users[1]],
        memberCount: 16,
        posts: [posts[1]],
        newSpillsCount: 4,
        category: GroupCategory.entertainment,
      ),
      Group(
        id: '3',
        name: 'Cash Me Outside',
        description: 'Financial tips, side hustles, and money talk',
        groupImage: 'assets/images/groups/group3.png',
        members: [users[2], users[0]],
        memberCount: 32,
        posts: [posts[2]],
        newSpillsCount: 5,
        category: GroupCategory.business,
      ),
      Group(
        id: '4',
        name: 'Yoga on Mondays',
        description: 'Start your week with zen and good vibes',
        groupImage: 'assets/images/groups/group4.png',
        members: [users[0], users[1], users[2]],
        memberCount: 32,
        posts: [posts[2]],
        newSpillsCount: 5,
        category: GroupCategory.fitness,
      ),
      Group(
        id: '5',
        name: 'Podcast Crew',
        description: 'Discuss your favorite podcasts and podcast hosts',
        groupImage: 'assets/images/groups/group5.png',
        members: [users[0], users[2]],
        memberCount: 48,
        posts: [posts[0]],
        newSpillsCount: 3,
        category: GroupCategory.entertainment,
      ),
      Group(
        id: '6',
        name: 'BMX L.A.',
        description: 'BMX riders in Los Angeles area sharing spots and tricks',
        groupImage: 'assets/images/groups/group6.png',
        members: [users[1]],
        memberCount: 87,
        posts: [posts[2]],
        newSpillsCount: 7,
        category: GroupCategory.sports,
      ),
      Group(
        id: '7',
        name: 'Music Appreciation',
        description: 'Share and discover new music across all genres',
        groupImage: 'assets/images/groups/group7.png',
        members: [users[0], users[1]],
        memberCount: 156,
        posts: [posts[0]],
        newSpillsCount: 12,
        category: GroupCategory.music,
      ),
      Group(
        id: '8',
        name: 'News Junkies',
        description: 'Breaking news and in-depth discussions',
        groupImage: 'assets/images/groups/group8.png',
        members: [users[2]],
        memberCount: 92,
        posts: [posts[1]],
        newSpillsCount: 8,
        category: GroupCategory.news,
      ),
      Group(
        id: '9',
        name: 'Political Debates',
        description: 'Civil discussions on current political issues',
        groupImage: 'assets/images/groups/group9.png',
        members: [users[0], users[2]],
        memberCount: 74,
        posts: [posts[2]],
        newSpillsCount: 6,
        category: GroupCategory.politics,
      ),
      Group(
        id: '10',
        name: 'Hip Hop Heads',
        description: 'Everything about hip hop culture and music',
        groupImage: 'assets/images/groups/group10.png',
        members: [users[1]],
        memberCount: 128,
        posts: [posts[0]],
        newSpillsCount: 9,
        category: GroupCategory.hipHop,
      ),
    ]);

    // Set initially joined groups
    _joinedGroups.addAll([
      _groups[0],  // In My Bag
      _groups[3],  // Yoga on Mondays
    ]);

    // Mark groups as joined
    _groups[0] = _groups[0].copyWith(isJoined: true);
    _groups[3] = _groups[3].copyWith(isJoined: true);
  }
}
