import 'package:flutter/material.dart';
import '../widgets/post_item.dart';
import '../models/post.dart';
import 'compose_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Sample data to populate the feed based on the screenshot
  final List<Post> _posts = [
    Post(
      username: 'wanderlust_gypsy',
      profileImage: 'assets/images/profile1.jpg',
      content: "Me: 'I'm going to bed #earlytonight.' Also me at 3 AM: watching a raccoon wash grapes in slow motion",
      memeImage: 'assets/images/thinking_meme.jpg',  // Rolling eyes meme
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

  int _selectedIndex = 0;

  // Method to navigate to compose screen
  void _navigateToComposeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ComposeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          return PostItem(post: _posts[index]);
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
            const BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none),
              activeIcon: Icon(Icons.notifications),
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
    );
  }
}