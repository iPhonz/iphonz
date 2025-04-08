import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/group.dart';
import '../screens/comments_screen.dart';
import '../screens/group_detail_screen.dart';
import '../services/comment_service.dart';
import '../services/group_service.dart';
import '../utils/app_theme.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onToggleJoin;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final Group? group; // Optional group parameter if post is from a group
  final bool showJoinButton; // Option to hide the join button in some contexts

  const PostItem({
    Key? key,
    required this.post,
    this.onLike,
    this.onToggleJoin,
    this.onComment,
    this.onShare,
    this.group,
    this.showJoinButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentService = CommentService();
    final comments = commentService.getCommentsForPost(post.id);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header with profile image and username
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Profile image
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(post.user.profileImage),
                ),
                const SizedBox(width: 10),
                
                // Username and tagline/group
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      if (group != null)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroupDetailScreen(group: group!),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.group,
                                size: 14,
                                color: AppTheme.purpleAccent,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                group!.name,
                                style: TextStyle(
                                  color: AppTheme.purpleAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (post.user.bio != null && post.user.bio!.isNotEmpty)
                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              post.user.bio!,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                
                // Joined button (if enabled)
                if (showJoinButton && (group != null || post.isJoined != null))
                  GestureDetector(
                    onTap: onToggleJoin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: (group?.isJoined ?? post.isJoined ?? false) 
                            ? AppTheme.purpleAccent 
                            : null,
                        borderRadius: BorderRadius.circular(20),
                        border: (group?.isJoined ?? post.isJoined ?? false) 
                            ? null 
                            : Border.all(color: AppTheme.coral),
                      ),
                      child: Text(
                        (group?.isJoined ?? post.isJoined ?? false) ? 'Joined' : 'Join',
                        style: TextStyle(
                          color: (group?.isJoined ?? post.isJoined ?? false) 
                              ? Colors.white 
                              : AppTheme.coral,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Post content
          if (post.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  children: _buildTextWithHashtags(post.content),
                ),
              ),
            ),
          
          // Post image if available
          if (post.imageUrl != null)
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                maxHeight: 400,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(post.imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(),
              ),
            ),
          
          // Post engagement buttons
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Send/Share button
                GestureDetector(
                  onTap: onShare,
                  child: _buildEngagementButton(
                    icon: Icons.send_outlined,
                    count: null,
                  ),
                ),
                
                // Comments button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(post: post),
                      ),
                    );
                  },
                  child: _buildEngagementButton(
                    icon: Icons.chat_bubble_outline,
                    count: comments.isNotEmpty ? comments.length : post.comments,
                  ),
                ),
                
                // Like button
                GestureDetector(
                  onTap: onLike,
                  child: _buildEngagementButton(
                    icon: Icons.coffee_outlined,
                    count: post.likes > 0 ? post.likes : null,
                  ),
                ),
              ],
            ),
          ),
          
          // Display timestamp
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
            child: Text(
              _getTimeAgo(post.timestamp),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build engagement buttons
  Widget _buildEngagementButton({
    required IconData icon,
    required int? count,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
        if (count != null) ...[  
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }

  // Helper method to parse hashtags in text
  List<TextSpan> _buildTextWithHashtags(String text) {
    final List<TextSpan> spans = [];
    final words = text.split(' ');
    
    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      if (word.startsWith('#')) {
        spans.add(
          TextSpan(
            text: word,
            style: TextStyle(
              color: AppTheme.purpleAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        spans.add(TextSpan(text: word));
      }
      
      // Add space between words (except for the last word)
      if (i < words.length - 1) {
        spans.add(const TextSpan(text: ' '));
      }
    }
    
    return spans;
  }
  
  // Helper method to format timestamp
  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }
}