import 'package:flutter/material.dart';
import '../../models/message.dart';
import '../../models/user.dart';
import '../../utils/app_theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isCurrentUser;
  final User? user;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isCurrentUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(user!.profileImage),
              backgroundColor: AppTheme.purpleAccent,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isCurrentUser 
                    ? AppTheme.messageBubbleOutgoing
                    : AppTheme.messageBubbleIncoming,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isCurrentUser ? 20 : 5),
                  bottomRight: Radius.circular(isCurrentUser ? 5 : 20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.type == MessageType.image && message.mediaUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        message.mediaUrl!,
                        width: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.image_not_supported,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  if (message.content.isNotEmpty)
                    Text(
                      message.content,
                      style: TextStyle(
                        color: isCurrentUser 
                            ? AppTheme.messageTextOutgoing 
                            : AppTheme.messageTextIncoming,
                        fontSize: 16,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timeago.format(message.timestamp),
                        style: TextStyle(
                          color: isCurrentUser 
                              ? AppTheme.messageTextOutgoing.withOpacity(0.7) 
                              : AppTheme.messageTextIncoming.withOpacity(0.7),
                          fontSize: 11,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead 
                              ? Icons.done_all 
                              : Icons.done,
                          size: 14,
                          color: message.isRead 
                              ? Colors.lightBlue.shade200 
                              : AppTheme.messageTextOutgoing.withOpacity(0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser) const SizedBox(width: 24),
        ],
      ),
    );
  }
}