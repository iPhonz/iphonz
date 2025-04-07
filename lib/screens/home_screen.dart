import 'package:flutter/material.dart';
import '../widgets/post_item.dart';
import '../models/post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Sample data to populate the feed
  final List<Post> _posts = [
    Post(
      username: 'wanderlust_gypsy',
      profileImage: 'assets/images/profile1.jpg',
      content: 'Sometimes it just makes more sense to just rest. #inmybag #skateboarding',
      likes: 16,
      comments: 0,
      shares: 4,
    ),
    Post(
      username: 'wanderlust_gypsy',
      profileImage: 'assets/images/profile2.jpg',
      content: 'Sometimes it just makes more sense to just rest. #inmybag #skateboarding',
      likes: 16,
      comments: 0,
      shares: 4,
    ),
    Post(
      username: 'wanderlust_gypsy',
      profileImage: 'assets/images/profile3.jpg',
      content: 'Sometimes it just makes more sense to just rest. #inmybag #skateboarding',
      likes: 16,
      comments: 0,
      shares: 4,
    ),
    Post(
      username: 'wanderlust_gypsy',
      profileImage: 'assets/images/profile4.jpg',
      content: 'Sometimes it just makes more sense to just rest. #inmybag #skateboarding',
      likes: 16,
      comments: 0,
      shares: 4,
    ),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SPILL',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: _posts.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return PostItem(post: _posts[index]);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
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
    );
  }
}