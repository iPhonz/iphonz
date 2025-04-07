import '../models/notification_item.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // In-memory notifications storage
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

  // Callbacks for notification updates
  List<Function()> _listeners = [];

  // Add a listener
  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  // Remove a listener
  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  // Notify all listeners
  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  // Get all notifications
  List<NotificationItem> getNotifications() {
    return List.unmodifiable(_notifications);
  }

  // Get unread notifications
  List<NotificationItem> getUnreadNotifications() {
    return _notifications.where((notification) => notification.hasUnread).toList();
  }

  // Get notifications by type
  List<NotificationItem> getNotificationsByType(NotificationType type) {
    return _notifications.where((notification) => notification.type == type).toList();
  }

  // Get group notifications
  List<NotificationItem> getGroupNotifications() {
    return _notifications.where((notification) => 
      notification.type == NotificationType.groupRequest ||
      notification.type == NotificationType.groupJoin ||
      notification.type == NotificationType.groupPost
    ).toList();
  }

  // Get friend request notifications
  List<NotificationItem> getFriendRequestNotifications() {
    return _notifications.where((notification) => 
      notification.type == NotificationType.friendRequest
    ).toList();
  }

  // Mark notification as read
  void markAsRead(NotificationItem notification) {
    final index = _notifications.indexOf(notification);
    if (index != -1) {
      _notifications[index].hasUnread = false;
      _notifyListeners();
    }
  }

  // Approve a request (friend or group)
  void approveRequest(NotificationItem notification) {
    final index = _notifications.indexOf(notification);
    if (index != -1) {
      // In a real app, we would handle the approval logic here
      // For now, just mark it as read
      _notifications[index].hasUnread = false;
      _notifyListeners();
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.hasUnread = false;
    }
    _notifyListeners();
  }

  // Get unread count
  int getUnreadCount() {
    return _notifications.where((notification) => notification.hasUnread).length;
  }
}