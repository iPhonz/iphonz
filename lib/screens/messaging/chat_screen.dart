import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/message.dart';
import '../../models/user.dart';
import '../../services/messaging_service.dart';
import '../../widgets/messaging/message_bubble.dart';
import '../../utils/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final User otherUser;
  final String conversationId;
  final MessagingService messagingService;

  const ChatScreen({
    Key? key,
    required this.otherUser,
    required this.conversationId,
    required this.messagingService,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];
  bool _isLoading = true;
  String? _currentUserId;
  File? _imageFile;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadMessages();
    _listenToMessages();
  }

  Future<void> _loadCurrentUser() async {
    // Normally you would get this from your auth service
    _currentUserId = await widget.messagingService.userService.getCurrentUserId();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final messages = await widget.messagingService.getMessagesForConversation(widget.conversationId);
      setState(() {
        _messages = messages;
      });

      // Mark messages as read
      for (final message in messages) {
        if (message.receiverId == _currentUserId && !message.isRead) {
          widget.messagingService.markMessageAsRead(message.id, widget.conversationId);
        }
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load messages: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      
      // Scroll to the bottom
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _listenToMessages() {
    widget.messagingService.messages.listen((updatedMessages) {
      final conversationMessages = updatedMessages
          .where((m) => m.conversationId == widget.conversationId)
          .toList();
      
      if (conversationMessages.isNotEmpty) {
        setState(() {
          _messages = conversationMessages;
        });
        
        // Mark received messages as read
        for (final message in conversationMessages) {
          if (message.receiverId == _currentUserId && !message.isRead) {
            widget.messagingService.markMessageAsRead(message.id, widget.conversationId);
          }
        }
        
        // Scroll to bottom if new message
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty && _imageFile == null) return;

    // Clear the input field
    _messageController.clear();
    
    // Store the image file temporarily before clearing state
    final imageFileToSend = _imageFile;
    
    setState(() {
      _isTyping = false;
      _imageFile = null;
    });

    if (_currentUserId == null) return;

    try {
      // Send text message
      if (text.isNotEmpty) {
        await widget.messagingService.sendMessage(
          senderId: _currentUserId!,
          receiverId: widget.otherUser.id,
          content: text,
        );
      }
      
      // Send image message if there's an image
      if (imageFileToSend != null) {
        // In a real app, this would upload to a server and get a URL
        // For now, create a URL from the local path with a special prefix
        final imageUrl = 'file://${imageFileToSend.path}';
        
        await widget.messagingService.sendMessage(
          senderId: _currentUserId!,
          receiverId: widget.otherUser.id,
          content: text.isEmpty ? "Image sent" : text,  // Use the text if provided, otherwise use default
          mediaUrl: imageUrl,
          type: MessageType.image,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.otherUser.profileImage),
              radius: 16,
              backgroundColor: AppTheme.purpleAccent,
            ),
            const SizedBox(width: 12),
            Text(
              widget.otherUser.displayName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Show user profile or conversation details
            },
          ),
        ],
      ),
      body: Container(
        decoration: AppTheme.messageGradientBackground,
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : _messages.isEmpty
                      ? _buildEmptyState()
                      : _buildMessageList(),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.message_outlined,
              size: 40,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No messages yet with ${widget.otherUser.displayName}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Send a message to start the conversation',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isCurrentUser = message.senderId == _currentUserId;
        
        return MessageBubble(
          message: message,
          isCurrentUser: isCurrentUser,
          user: isCurrentUser ? null : widget.otherUser,
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_imageFile != null) _buildImagePreview(),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.photo),
                onPressed: _pickImage,
                color: AppTheme.purpleAccent,
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 16,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (value) {
                    setState(() {
                      _isTyping = value.trim().isNotEmpty;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _isTyping || _imageFile != null ? _sendMessage : null,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isTyping || _imageFile != null 
                        ? AppTheme.purpleAccent 
                        : Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        Container(
          height: 100,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: FileImage(_imageFile!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _imageFile = null;
              });
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}