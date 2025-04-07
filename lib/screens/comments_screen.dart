import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../models/user.dart';
import '../services/comment_service.dart';
import '../services/user_service.dart';
import '../widgets/comment_item.dart';

class CommentsScreen extends StatefulWidget {
  final Post post;
  
  const CommentsScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final CommentService _commentService = CommentService();
  final UserService _userService = UserService();
  final TextEditingController _commentController = TextEditingController();
  late List<Comment> _comments;
  Comment? _replyingTo;

  @override
  void initState() {
    super.initState();
    _comments = _commentService.getCommentsForPost(widget.post.id);
    _commentService.addListener(_refreshComments);
    _userService.init(); // Initialize user service
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentService.removeListener(_refreshComments);
    _focusNode.dispose();
    super.dispose();
  }

  void _refreshComments() {
    setState(() {
      _comments = _commentService.getCommentsForPost(widget.post.id);
    });
  }

  void _handleSubmitComment() {
    final content = _commentController.text.trim();
    
    if (content.isNotEmpty) {
      if (_replyingTo != null) {
        // Add a reply to the selected comment
        _commentService.addReply(
          commentId: _replyingTo!.id,
          username: _userService.currentUser.username,
          profileImage: _userService.currentUser.profileImage,
          content: content,
        );
        
        // Reset replying state
        setState(() {
          _replyingTo = null;
        });
      } else {
        // Add a new top-level comment
        _commentService.addComment(
          postId: widget.post.id,
          username: _userService.currentUser.username,
          profileImage: _userService.currentUser.profileImage,
          content: content,
        );
      }
      
      // Clear the input field
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Comments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Post summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(widget.post.user.profileImage),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.post.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          
          // Comments list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return CommentItem(
                  comment: comment,
                  onReply: () {
                    setState(() {
                      _replyingTo = comment;
                      _commentController.text = '@${comment.username} ';
                      
                      // Focus the text field
                      FocusScope.of(context).requestFocus(FocusNode());
                      Future.delayed(const Duration(milliseconds: 100), () {
                        FocusScope.of(context).requestFocus(_focusNode);
                      });
                    });
                  },
                );
              },
            ),
          ),
          
          // Comment input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E),
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Show who we're replying to, if any
                if (_replyingTo != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Text(
                          'Replying to ${_replyingTo!.username}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _replyingTo = null;
                              _commentController.clear();
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Comment input field
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage(_userService.currentUser.profileImage),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        focusNode: _focusNode,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Add your comment',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ),
                    ),
                    IconButton(
                      onPressed: _handleSubmitComment,
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Focus node for comment input
  final FocusNode _focusNode = FocusNode();
}
