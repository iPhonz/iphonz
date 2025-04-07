import 'package:flutter/material.dart';
import '../models/notification_item.dart';
import '../widgets/notification_item_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Current selected filter
  String _selectedFilter = 'All';
  
  // List of filter options
  final List<String> _filters = ['All', 'New', 'Friend Requests', 'Groups', 'Comments'];

  // Sample notification data
  final List<NotificationItem> _notifications = [
    // Group section
    NotificationItem(
      type: NotificationType.groupRequest,
      username: 'mountain_mama',
      profileImage: 'assets/images/profile_mountain_mama.jpg',
      message: 'requested to join:',
      group: 'In My Bag',
      hasUnread: true,
    ),
    NotificationItem(
      type: NotificationType.groupJoin,
      username: 'adventureratheart',
      profileImage: 'assets/images/profile_adventurer.jpg',
      message: 'joined:',
      group: 'For All My Folks',
      hasUnread: false,
    ),
    NotificationItem(
      type: NotificationType.groupPost,
      username: 'tropicalparadise',
      profileImage: 'assets/images/profile_tropical.jpg',
      message: 'posted a Spill in:',
      group: 'Not Today Baby',
      postImage: 'assets/images/post_purple.jpg',
      hasUnread: true,
    ),
    NotificationItem(
      type: NotificationType.groupPost,
      username: 'tuneblueberry',
      profileImage: 'assets/images/profile_tune.jpg',
      message: 'posted a Spill in:',
      group: 'ReallyTho?',
      postImage: 'assets/images/post_baby.jpg',
      hasUnread: false,
    ),
    NotificationItem(
      type: NotificationType.groupPost,
      username: 'guitarsodawave',
      profileImage: 'assets/images/profile_guitar.jpg',
      message: 'posted a Spill in:',
      group: 'Yoga on Mondays',
      postImage: 'assets/images/post_yoga.jpg',
      hasUnread: false,
    ),
    NotificationItem(
      type: NotificationType.groupPost,
      username: 'pastaleloiancha',
      profileImage: 'assets/images/profile_pasta.jpg',
      message: 'posted a Spill in:',
      group: 'Cash Me Outside',
      postImage: 'assets/images/post_cash.jpg',
      hasUnread: false,
    ),
    
    // Friend requests section
    NotificationItem(
      type: NotificationType.friendRequest,
      username: 'curious_kat',
      profileImage: 'assets/images/profile_curious.jpg',
      message: 'requested to connect',
      hasUnread: true,
    ),
    NotificationItem(
      type: NotificationType.friendRequest,
      username: 'currantbaseball',
      profileImage: 'assets/images/profile_currant.jpg',
      message: 'requested to connect',
      hasUnread: true,
    ),
  ];

  // Filtered notifications based on current filter
  List<NotificationItem> get filteredNotifications {
    if (_selectedFilter == 'All') {
      return _notifications;
    } else if (_selectedFilter == 'New') {
      return _notifications.where((item) => item.hasUnread).toList();
    } else if (_selectedFilter == 'Friend Requests') {
      return _notifications.where((item) => item.type == NotificationType.friendRequest).toList();
    } else if (_selectedFilter == 'Groups') {
      return _notifications.where((item) => 
        item.type == NotificationType.groupRequest || 
        item.type == NotificationType.groupJoin || 
        item.type == NotificationType.groupPost
      ).toList();
    } else if (_selectedFilter == 'Comments') {
      return _notifications.where((item) => item.type == NotificationType.comment).toList();
    }
    return _notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A1C5A), // Dark purple background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter tabs
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Notification list with sections
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _buildSectionedList().length,
              itemBuilder: (context, index) {
                final item = _buildSectionedList()[index];
                
                if (item is String) {
                  // This is a section header
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (index < _buildSectionedList().length - 1 && 
                            _buildSectionedList()[index + 1] is String)
                          const Divider(color: Colors.white24, thickness: 1),
                      ],
                    ),
                  );
                } else if (item is NotificationItem) {
                  // This is a notification item
                  return NotificationItemWidget(
                    notification: item,
                    onApprove: () {
                      // Handle approval
                      setState(() {
                        item.hasUnread = false;
                      });
                    },
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build list with section headers
  List<dynamic> _buildSectionedList() {
    final List<dynamic> sectionedList = [];
    
    // Group section if there are group notifications
    final groupNotifications = filteredNotifications.where((item) => 
      item.type == NotificationType.groupRequest || 
      item.type == NotificationType.groupJoin || 
      item.type == NotificationType.groupPost
    ).toList();
    
    if (groupNotifications.isNotEmpty) {
      sectionedList.add('Groups');
      sectionedList.addAll(groupNotifications);
    }
    
    // Add a divider if we have more sections
    if (groupNotifications.isNotEmpty) {
      sectionedList.add(''); // Empty string as divider marker
    }
    
    // Friend requests section if there are friend requests
    final friendRequests = filteredNotifications.where((item) => 
      item.type == NotificationType.friendRequest
    ).toList();
    
    if (friendRequests.isNotEmpty) {
      sectionedList.add('Friend Requests');
      sectionedList.addAll(friendRequests);
    }
    
    return sectionedList;
  }
}