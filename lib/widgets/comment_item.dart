import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../services/comment_service.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final String? parentCommentId;
  final bool isReply;
  final VoidCallback? onReply;
  
  const CommentItem({
    Key? key,
    required this.comment,
    this.parentCommentId,
    this.isReply = false,
    this.onReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentService = CommentService();
    
    return Container(
      padding: EdgeInsets.only(
        left: isReply ? 40.0 : 0.0,
        bottom: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment header with profile pic and username
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile picture
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(comment.profileImage),
              ),
              const SizedBox(width: 12),
              
              // Username and content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username
                    Text(
                      comment.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    
                    // Comment content
                    Text(
                      comment.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    
                    // Comment image if available
                    if (comment.hasImage && comment.imageUrl != null)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(comment.imageUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    
                    // Reply and like buttons
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Reply button
                        TextButton(
                          onPressed: onReply,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Reply',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        
                        // Comment stats (likes)
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${comment.likes}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                onPressed: () {
                                  if (isReply && parentCommentId != null) {
                                    commentService.likeReply(parentCommentId!, comment.id);
                                  } else {
                                    commentService.likeComment(comment.id);
                                  }
                                },
                                icon: const Icon(
                                  Icons.coffee_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Replies section
          if (comment.replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: comment.replies.map((reply) {
                  return CommentItem(
                    comment: reply,
                    parentCommentId: comment.id,
                    isReply: true,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}