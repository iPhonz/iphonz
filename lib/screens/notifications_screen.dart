import 'package:flutter/material.dart';
import '../models/notification_item.dart';
import '../widgets/notification_item_widget.dart';
import '../services/notification_service.dart';
import '../utils/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  // Added parameter to control whether to show the back button
  final bool showBackButton;
  
  const NotificationsScreen({Key? key, this.showBackButton = false}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Current selected filter
  String _selectedFilter = 'All';
  
  // List of filter options
  final List<String> _filters = ['All', 'New', 'Friend Requests', 'Groups', 'Comments'];

  // Notification service
  final NotificationService _notificationService = NotificationService();
  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = _notificationService.getNotifications();
    _notificationService.addListener(_refreshNotifications);
  }

  @override
  void dispose() {
    _notificationService.removeListener(_refreshNotifications);
    super.dispose();
  }

  void _refreshNotifications() {
    setState(() {
      _notifications = _notificationService.getNotifications();
    });
  }

  // Filtered notifications based on current filter
  List<NotificationItem> get filteredNotifications {
    if (_selectedFilter == 'All') {
      return _notifications;
    } else if (_selectedFilter == 'New') {
      return _notificationService.getUnreadNotifications();
    } else if (_selectedFilter == 'Friend Requests') {
      return _notificationService.getFriendRequestNotifications();
    } else if (_selectedFilter == 'Groups') {
      return _notificationService.getGroupNotifications();
    } else if (_selectedFilter == 'Comments') {
      return _notificationService.getNotificationsByType(NotificationType.comment);
    }
    return _notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Use transparent background to work with gradient
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Only show back button if showBackButton is true
        leading: widget.showBackButton ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ) : null,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: AppTheme.purpleGradientBackground,
        child: SafeArea(
          child: Column(
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
                            if (index > 0 && index < _buildSectionedList().length - 1)
                              const Divider(color: Colors.white24, thickness: 1),
                          ],
                        ),
                      );
                    } else if (item is NotificationItem) {
                      // This is a notification item
                      return NotificationItemWidget(
                        notification: item,
                        onApprove: () {
                          _notificationService.approveRequest(item);
                        },
                      );
                    }
                    
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
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
    if (groupNotifications.isNotEmpty && 
        filteredNotifications.any((item) => item.type == NotificationType.friendRequest)) {
      sectionedList.add('');
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