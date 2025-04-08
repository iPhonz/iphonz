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
  int _selectedIndex = 0;
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

  // Method to navigate to compose screen
  void _navigateToComposeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ComposeScreen()),
    );
  }
  
  // Method to navigate to notifications screen
  void _navigateToNotificationsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );
  }
  
  // Method to navigate to profile screen
  void _navigateToProfileScreen() {
    final currentUserId = _userService.getCurrentUserId() ?? '';
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(userId: currentUserId)),
    );
  }
  
  // Method to navigate to groups screen
  void _navigateToGroupsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GroupsScreen()),
    );
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
    // Get unread notifications count
    final unreadCount = _notificationService.getUnreadCount();
    
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
      // Only keep the bottom navigation bar
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            border: Border(
              top: BorderSide(
                color: Colors.black,
                width: 0.5,
              ),
            ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: AppTheme.purpleAccent,
            unselectedItemColor: Colors.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: _selectedIndex,
            elevation: 0,
            onTap: (index) {
              setState(() {
                if (index == 2) {
                  // Navigate to compose screen when the center "+" button is tapped
                  _navigateToComposeScreen();
                } else if (index == 3) {
                  // Navigate to notifications screen when the notifications icon is tapped
                  _navigateToNotificationsScreen();
                } else if (index == 4) {
                  // Navigate to profile screen when the profile icon is tapped
                  _navigateToProfileScreen();
                } else if (index == 1) {
                  // Navigate to groups screen when the groups icon is tapped
                  _navigateToGroupsScreen();
                } else {
                  _selectedIndex = index;
                }
              });
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.group_outlined),
                activeIcon: Icon(Icons.group),
                label: 'Groups',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.purpleAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 30),
                ),
                label: 'Create',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_none),
                    if (unreadCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 8,
                            minHeight: 8,
                          ),
                        ),
                      ),
                  ],
                ),
                activeIcon: const Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage(_userService.currentUser.profileImage),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}