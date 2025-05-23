import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/groups_screen.dart';
import 'screens/compose_screen.dart';
import 'screens/messaging/conversations_screen.dart';
import 'services/user_service.dart';
import 'services/post_service.dart';
import 'services/group_service.dart';
import 'services/messaging_service.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const SpillApp());
}

class SpillApp extends StatelessWidget {
  const SpillApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set status bar color to match the app design
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserService>(
          create: (_) => UserService(),
        ),
        Provider<PostService>(
          create: (_) => PostService(),
        ),
        ChangeNotifierProvider<GroupService>(
          create: (_) => GroupService(),
        ),
        ProxyProvider<UserService, MessagingService>(
          update: (_, userService, __) => MessagingService(userService: userService),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SPILL',
        theme: AppTheme.darkTheme,
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get services
    final userService = Provider.of<UserService>(context);
    final messagingService = Provider.of<MessagingService>(context);
    
    // Get the current user ID
    final currentUserId = userService.getCurrentUserId() ?? '';
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.purpleDark,
              AppTheme.purpleMedium.withOpacity(0.8),
              Colors.black
            ],
          ),
        ),
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            // Home screen
            HomeScreen(userId: currentUserId),
            
            // Groups screen - specifying showBackButton as false to prevent the back button from being shown
            const GroupsScreen(showBackButton: false),
            
            // Compose screen placeholder - will be shown as modal
            Container(),
            
            // Notifications screen with showBackButton set to false
            const NotificationsScreen(showBackButton: false),
            
            // Profile screen
            ProfileScreen(userId: currentUserId),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            // If the compose button (index 2) is tapped, show compose screen as modal
            if (index == 2) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const ComposeScreen(),
              );
            } else {
              setState(() {
                _selectedIndex = index;
              });
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: AppTheme.purpleAccent,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
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
            const BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}