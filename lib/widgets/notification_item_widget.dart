import 'package:flutter/material.dart';
import '../models/notification_item.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback? onApprove;

  const NotificationItemWidget({
    Key? key,
    required this.notification,
    this.onApprove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unread indicator dot
          if (notification.hasUnread)
            Container(
              margin: const EdgeInsets.only(top: 25, right: 8),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
          
          // Profile image
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(notification.profileImage),
          ),
          
          const SizedBox(width: 12),
          
          // Notification content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username and action
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    children: [
                      TextSpan(
                        text: notification.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' ${notification.message} '),
                      if (notification.group != null)
                        TextSpan(
                          text: notification.group!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
                
                // Approve button for requests
                if (notification.hasApproveAction) 
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                      onPressed: onApprove,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      ),
                      child: const Text(
                        'Approve',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Post thumbnail image if available
          if (notification.postImage != null)
            Container(
              margin: const EdgeInsets.only(left: 12),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(notification.postImage!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }
}