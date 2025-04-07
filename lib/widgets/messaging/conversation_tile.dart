import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationTile extends StatelessWidget {
  final User user;
  final String? lastMessage;
  final DateTime? timestamp;
  final bool hasUnread;
  final VoidCallback onTap;

  const ConversationTile({
    Key? key,
    required this.user,
    this.lastMessage,
    this.timestamp,
    this.hasUnread = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: hasUnread 
              ? Colors.white.withOpacity(0.1) 
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(user.profileImage),
                ),
                if (hasUnread)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        user.displayName,
                        style: TextStyle(
                          fontWeight: hasUnread 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      if (timestamp != null)
                        Text(
                          timeago.format(timestamp!),
                          style: TextStyle(
                            fontSize: 12,
                            color: hasUnread 
                                ? Colors.white 
                                : Colors.white70,
                            fontWeight: hasUnread 
                                ? FontWeight.bold 
                                : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage ?? 'Start a conversation',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: hasUnread 
                          ? Colors.white.withOpacity(0.9) 
                          : Colors.white70,
                      fontWeight: hasUnread 
                          ? FontWeight.w500 
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}