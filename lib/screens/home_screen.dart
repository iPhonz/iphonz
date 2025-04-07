import 'package:flutter/material.dart';
import '../widgets/post_item.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import '../services/notification_service.dart';
import 'compose_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PostService _postService = PostService();
  final NotificationService _notificationService = NotificationService();
  late List<Post> _posts;
  
  @override
  void initState() {
    super.initState();
    _posts = _postService.getPosts();
    _postService.addListener(_refreshPosts);
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

  @override
  Widget build(BuildContext context) {
    // Get unread notifications count
    final unreadCount = _notificationService.getUnreadCount();
    
    return Scaffold(
      // Use a gradient background color
      backgroundColor: const Color(0xFFF8E4E8),
      // Custom AppBar with SPILL title and search icon
      appBar: AppBar(
        title: const Text(
          'SPILL',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          // Search icon
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
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
      // Custom bottom navigation bar with purple accent
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF7941FF), // Purple color
          unselectedItemColor: Colors.grey,
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
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Friends',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFF7941FF),
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
                backgroundImage: AssetImage('assets/images/user_profile.jpg'),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
      // Floating action button for quick compose access
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToComposeScreen,
        backgroundColor: const Color(0xFF7941FF),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}