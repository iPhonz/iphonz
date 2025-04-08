import 'package:flutter/material.dart';
import '../../models/conversation.dart';
import '../../models/user.dart';
import '../../services/messaging_service.dart';
import '../../services/user_service.dart';
import '../../utils/app_theme.dart';
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
  bool _hasError = false;
  String? _errorMessage;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _listenToConversations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This will ensure data is refreshed when navigating back to this screen
    _refreshData();
  }

  void _refreshData() {
    if (_currentUserId != null) {
      _loadConversations();
    }
  }

  Future<void> _loadCurrentUser() async {
    _currentUserId = await widget.userService.getCurrentUserId();
    if (_currentUserId != null) {
      _loadConversations();
    }
  }

  Future<void> _loadConversations() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _errorMessage = null;
      });
    }

    try {
      final conversations = await widget.messagingService.getConversationsForUser(_currentUserId!);
      
      // Preload user data for all participants
      for (final conversation in conversations) {
        for (final userId in conversation.participantIds) {
          if (userId != _currentUserId && !_userCache.containsKey(userId)) {
            final user = await widget.userService.getUserById(userId);
            if (user != null && mounted) {
              setState(() {
                _userCache[userId] = user;
              });
            }
          }
        }
      }
      
      if (mounted) {
        setState(() {
          _conversations = conversations;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Failed to load conversations: $e';
        });
      }
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load conversations: $e')),
      );
    }
  }

  void _listenToConversations() {
    widget.messagingService.conversations.listen((updatedConversations) {
      if (mounted) {
        setState(() {
          _conversations = updatedConversations;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
        decoration: AppTheme.messageGradientBackground,
        child: RefreshIndicator(
          onRefresh: _loadConversations,
          color: AppTheme.purpleAccent,
          child: _buildMainContent(),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Loading conversations...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'An error occurred',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadConversations,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppTheme.purpleAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_conversations.isEmpty) {
      return _buildEmptyState();
    } else {
      return _buildConversationList();
    }
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        // New message card at the top
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'New Message',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for a user',
                    hintStyle: const TextStyle(
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF666666)),
                    fillColor: const Color(0xFFF5F5F5),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: () {
                    // Open search dialog
                    _showNewMessageDialog();
                  },
                ),
              ),
              const SizedBox(height: 16),
              // User list would go here but we'll use placeholders for now
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: AppTheme.purpleAccent,
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF333333),
                            ),
                          ),
                          Text(
                            '@username',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: AppTheme.purpleAccent,
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF333333),
                            ),
                          ),
                          Text(
                            '@username',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        
        // Empty state message
        Center(
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
                child: const Icon(
                  Icons.message_outlined,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No messages yet',
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Send a message to start the conversation',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
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
          // Still loading user data, show a better loading placeholder
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.black12,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 16,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 200,
                        height: 12,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
            ).then((_) {
              // Refresh the conversations list when returning from the chat screen
              _refreshData();
            });
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for a user',
                    hintStyle: const TextStyle(
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF666666)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    fillColor: Colors.grey.shade100,
                    filled: true,
                  ),
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w500,
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
                        backgroundImage: AssetImage(user.profileImage),
                        radius: 24,
                      ),
                      title: Text(
                        user.displayName,
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        '@${user.username}',
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        
                        // Create or get conversation
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
                        ).then((_) {
                          // Refresh the conversations list when returning from the chat screen
                          _refreshData();
                        });
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
  
  @override
  void dispose() {
    // Make sure to clean up any resources if needed
    super.dispose();
  }
}