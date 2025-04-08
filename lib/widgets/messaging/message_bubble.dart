import 'package:flutter/material.dart';
import 'dart:io';
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
                  // Display image if present
                  if (message.type == MessageType.image && message.mediaUrl != null)
                    _buildMessageImage(message.mediaUrl!),
                  // Always display content text
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

  Widget _buildMessageImage(String mediaUrl) {
    // Check if this is a local file path (file:// prefix)
    if (mediaUrl.startsWith('file://')) {
      final filePath = mediaUrl.substring(7); // Remove 'file://' prefix
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 250,
            maxHeight: 300,
          ),
          child: Image.file(
            File(filePath),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildImageError(),
          ),
        ),
      );
    } else {
      // Remote image URL
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 250,
            maxHeight: 300,
          ),
          child: Image.network(
            mediaUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildImageLoading(loadingProgress);
            },
            errorBuilder: (context, error, stackTrace) => _buildImageError(),
          ),
        ),
      );
    }
  }

  Widget _buildImageLoading(ImageChunkEvent loadingProgress) {
    return Container(
      width: 200,
      height: 150,
      color: Colors.black12,
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded / 
                  loadingProgress.expectedTotalBytes!
              : null,
          strokeWidth: 2,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      width: 200,
      height: 150,
      color: Colors.black12,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 40,
            color: Colors.white54,
          ),
          SizedBox(height: 8),
          Text(
            'Image not available',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}