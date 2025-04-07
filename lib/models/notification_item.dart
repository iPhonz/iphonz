enum NotificationType {
  friendRequest,
  groupRequest,
  groupJoin,
  groupPost,
  comment,
}

class NotificationItem {
  final NotificationType type;
  final String username;
  final String profileImage;
  final String message;
  final String? group;
  final String? postImage;
  bool hasUnread;

  NotificationItem({
    required this.type,
    required this.username,
    required this.profileImage,
    required this.message,
    this.group,
    this.postImage,
    this.hasUnread = false,
  });

  // Check if notification has an approve action
  bool get hasApproveAction {
    return type == NotificationType.friendRequest || 
           type == NotificationType.groupRequest;
  }
}