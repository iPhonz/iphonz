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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header with profile image and username
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(post.profileImage),
                ),
                const SizedBox(width: 10),
                Column(
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
                          'All we do is skaaaate',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Post content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Text(
              post.content,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          
          // Post engagement buttons
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildEngagementButton(
                  icon: Icons.send,
                  count: null,
                ),
                _buildEngagementButton(
                  icon: Icons.repeat,
                  count: post.shares,
                ),
                _buildEngagementButton(
                  icon: Icons.chat_bubble_outline,
                  count: post.likes,
                ),
                _buildEngagementButton(
                  icon: Icons.local_cafe_outlined,
                  count: post.comments,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
}