import 'package:flutter/material.dart';
import '../../models/conversation.dart';
import '../../models/user.dart';
import '../../services/messaging_service.dart';
import '../../services/user_service.dart';
import 'chat_screen.dart';
import '../../widgets/messaging/conversation_tile.dart';

class ConversationsScreen extends StatefulWidget {
  final UserService userService;
  final MessagingService messagingService;

  const ConversationsScreen({
    Key? key,
    required this.userService,
    required this.messagingService,
  }) : super(key: key);

  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  List<Conversation> _conversations = [];
  Map<String, User> _userCache = {};
  bool _isLoading = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _listenToConversations();
  }

  Future<void> _loadCurrentUser() async {
    _currentUserId = await widget.userService.getCurrentUserId();
    if (_currentUserId != null) {
      _loadConversations();
    }
  }

  Future<void> _loadConversations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final conversations = await widget.messagingService.getConversationsForUser(_currentUserId!);
      setState(() {
        _conversations = conversations;
      });

      // Preload user data for all participants
      for (final conversation in conversations) {
        for (final userId in conversation.participantIds) {
          if (userId != _currentUserId && !_userCache.containsKey(userId)) {
            final user = await widget.userService.getUserById(userId);
            if (user != null) {
              setState(() {
                _userCache[userId] = user;
              });
            }
          }
        }
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load conversations: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _listenToConversations() {
    widget.messagingService.conversations.listen((updatedConversations) {
      setState(() {
        _conversations = updatedConversations;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Show search or new message UI
              _showNewMessageDialog();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.pink.shade300],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _conversations.isEmpty
                ? _buildEmptyState()
                : _buildConversationList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.message, size: 80, color: Colors.white70),
          const SizedBox(height: 16),
          const Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start a conversation with someone',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showNewMessageDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('New Message'),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _conversations.length,
      itemBuilder: (context, index) {
        final conversation = _conversations[index];
        final otherUserId = conversation.participantIds
            .firstWhere((id) => id != _currentUserId, orElse: () => '');
        
        final otherUser = _userCache[otherUserId];
        
        if (otherUser == null) {
          // Still loading user data
          return const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('Loading...', style: TextStyle(color: Colors.white)),
          );
        }
        
        return ConversationTile(
          user: otherUser,
          lastMessage: conversation.lastMessageContent,
          timestamp: conversation.lastMessageTimestamp,
          hasUnread: conversation.hasUnreadMessages,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  otherUser: otherUser,
                  conversationId: conversation.id,
                  messagingService: widget.messagingService,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showNewMessageDialog() async {
    final allUsers = await widget.userService.getAllUsers();
    final filteredUsers = allUsers
        .where((user) => 
            user.id != _currentUserId && 
            user.allowsMessages)
        .toList();
    
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'New Message',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for a user',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.profileImage),
                      ),
                      title: Text(user.displayName),
                      subtitle: Text('@${user.username}'),
                      onTap: () async {
                        Navigator.pop(context);
                        
                        // Create or get conversation
                        // Updated to use the public method instead of the private one
                        final conversationId = await widget.messagingService.getOrCreateConversation(
                          _currentUserId!,
                          user.id,
                        );
                        
                        if (!mounted) return;
                        
                        // Navigate to chat
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              otherUser: user,
                              conversationId: conversationId,
                              messagingService: widget.messagingService,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}