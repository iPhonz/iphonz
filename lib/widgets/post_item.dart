import 'package:flutter/material.dart';
import '../models/post.dart';
import '../screens/comments_screen.dart';
import '../services/comment_service.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onToggleJoin;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const PostItem({
    Key? key,
    required this.post,
    this.onLike,
    this.onToggleJoin,
    this.onComment,
    this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentService = CommentService();
    final comments = commentService.getCommentsForPost(post.id);
    
    return Container(
      color: Colors.black,
      margin: const EdgeInsets.only(bottom: 12.0),
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
                  backgroundImage: AssetImage(post.profileImage),
                ),
                const SizedBox(width: 10),
                
                // Username and tagline
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.people_outline,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            post.tagline ?? 'All we do is skaaaate',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Joined button
                GestureDetector(
                  onTap: onToggleJoin,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: post.hasJoined ? const Color(0xFF7941FF) : null,
                      borderRadius: BorderRadius.circular(20),
                      border: post.hasJoined ? null : Border.all(color: const Color(0xFF7941FF)),
                    ),
                    child: Text(
                      post.hasJoined ? 'Joined' : 'Join',
                      style: TextStyle(
                        color: post.hasJoined ? Colors.white : const Color(0xFF7941FF),
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
          
          // Meme image if available
          if (post.memeImage != null)
            Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(post.memeImage!),
                  fit: BoxFit.cover,
                ),
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
                    count: post.shares > 0 ? post.shares : null,
                  ),
                ),
                
                // Refresh/Repost button
                _buildEngagementButton(
                  icon: Icons.refresh_rounded,
                  count: post.shares > 0 ? post.shares : null,
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
                    count: comments.length > 0 ? comments.length : null,
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
            style: const TextStyle(
              color: Color(0xFF7941FF),
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
}