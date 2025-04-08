import 'package:flutter/material.dart';
import '../widgets/post_item.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import '../services/notification_service.dart';
import '../services/user_service.dart';
import '../services/group_service.dart';
import '../services/messaging_service.dart';
import '../utils/app_theme.dart';
import 'compose_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'groups_screen.dart';
import 'messaging/conversations_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? userId;
  
  const HomeScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostService _postService = PostService();
  final NotificationService _notificationService = NotificationService();
  final UserService _userService = UserService(); // Add user service for profile
  final GroupService _groupService = GroupService(); // Add group service
  late List<Post> _posts;
  
  @override
  void initState() {
    super.initState();
    _posts = _postService.getPosts();
    _postService.addListener(_refreshPosts);
    
    // Initialize user service
    _userService.init();
  }

  @override
  void dispose() {
    _postService.removeListener(_refreshPosts);
    super.dispose();
  }

  void _refreshPosts() {
    setState(() {
      _posts = _postService.getPosts();
    });
  }
  
  // Method to navigate to messaging screen
  void _navigateToMessagingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationsScreen(
          userService: _userService,
          messagingService: MessagingService(userService: _userService),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // Custom AppBar with SPILL title and search icon
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'SPILL',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          // Messaging icon
          IconButton(
            icon: const Icon(Icons.message_outlined, color: Colors.white),
            onPressed: _navigateToMessagingScreen,
          ),
          // Search icon in a circular container
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
      // Post list
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return PostItem(
            post: _posts[index],
            onLike: () => _postService.likePost(index),
            onToggleJoin: () => _postService.toggleJoin(index),
          );
        },
      ),
      // Removed the bottom navigation bar from here as it's already defined in main.dart
    );
  }
}