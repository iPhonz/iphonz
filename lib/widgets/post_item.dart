import 'package:flutter/material.dart';
import '../models/post.dart';

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
                Container(
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
              ],
            ),
          ),
          
          // Post content
          if (post.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 18, color: Colors.black),
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
                _buildEngagementButton(
                  icon: Icons.send_outlined,
                  count: null,
                ),
                
                // Likes count shown as 16
                _buildEngagementButton(
                  icon: Icons.chat_bubble_outline,
                  count: post.likes,
                ),
                
                // Comments count shown as 0
                _buildEngagementButton(
                  icon: Icons.coffee_outlined,
                  count: post.comments,
                ),
              ],
            ),
          ),
          
          // Comments section if available
          if (post.commentsList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: post.commentsList.map((comment) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: AssetImage(comment.profileImage),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                comment.content,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
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
          color: Colors.black,
        ),
        if (count != null) ...[  
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.black,
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