import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/message.dart';
import '../models/conversation.dart';
import '../models/user.dart';
import 'user_service.dart';

class MessagingService {
  // Sample in-memory storage for the demo
  final Map<String, Conversation> _conversations = {};
  final Map<String, List<Message>> _messages = {};
  
  // Stream controllers for real-time updates
  final _conversationsController = StreamController<List<Conversation>>.broadcast();
  final _messagesController = StreamController<List<Message>>.broadcast();
  
  // Services
  final UserService userService;
  
  MessagingService({required this.userService});
  
  // Getters for the streams
  Stream<List<Conversation>> get conversations => _conversationsController.stream;
  Stream<List<Message>> get messages => _messagesController.stream;
  
  // Get all conversations for the current user
  Future<List<Conversation>> getConversationsForUser(String userId) async {
    // Filter conversations where the user is a participant
    final userConversations = _conversations.values
        .where((conv) => conv.participantIds.contains(userId))
        .toList();
    
    // Sort by the most recent message
    userConversations.sort((a, b) {
      if (a.lastMessageTimestamp == null) return 1;
      if (b.lastMessageTimestamp == null) return -1;
      return b.lastMessageTimestamp!.compareTo(a.lastMessageTimestamp!);
    });
    
    _conversationsController.add(userConversations);
    return userConversations;
  }
  
  // Get all messages for a specific conversation
  Future<List<Message>> getMessagesForConversation(String conversationId) async {
    final conversationMessages = _messages[conversationId] ?? [];
    
    // Sort by timestamp
    conversationMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    _messagesController.add(conversationMessages);
    return conversationMessages;
  }
  
  // Send a new message
  Future<Message> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
    String? mediaUrl,
    MessageType type = MessageType.text,
  }) async {
    // Find or create a conversation between these users
    final conversationId = await getOrCreateConversation(senderId, receiverId);
    
    // Create the message
    final message = Message(
      id: const Uuid().v4(),
      senderId: senderId,
      receiverId: receiverId,
      conversationId: conversationId,
      content: content,
      timestamp: DateTime.now(),
      isRead: false,
      mediaUrl: mediaUrl,
      type: type,
    );
    
    // Add to messages collection
    if (!_messages.containsKey(conversationId)) {
      _messages[conversationId] = [];
    }
    _messages[conversationId]!.add(message);
    
    // Update the conversation with last message info
    final conversation = _conversations[conversationId]!;
    _conversations[conversationId] = conversation.copyWith(
      lastMessageContent: content,
      lastMessageTimestamp: message.timestamp,
      hasUnreadMessages: true,
    );
    
    // Notify subscribers
    _messagesController.add(_messages[conversationId]!);
    _conversationsController.add(_conversations.values.toList());
    
    return message;
  }
  
  // Mark a message as read
  Future<void> markMessageAsRead(String messageId, String conversationId) async {
    if (!_messages.containsKey(conversationId)) return;
    
    final messageIndex = _messages[conversationId]!.indexWhere((m) => m.id == messageId);
    if (messageIndex == -1) return;
    
    final message = _messages[conversationId]![messageIndex];
    _messages[conversationId]![messageIndex] = message.copyWith(isRead: true);
    
    // Check if all messages are read
    final allRead = _messages[conversationId]!.every((m) => m.isRead);
    if (allRead) {
      final conversation = _conversations[conversationId]!;
      _conversations[conversationId] = conversation.copyWith(hasUnreadMessages: false);
      _conversationsController.add(_conversations.values.toList());
    }
    
    _messagesController.add(_messages[conversationId]!);
  }
  
  // Start a new conversation or get existing one
  // Changed from private (_getOrCreateConversation) to public (getOrCreateConversation)
  Future<String> getOrCreateConversation(String user1Id, String user2Id) async {
    // Check if conversation already exists
    final existingConversation = _conversations.values.firstWhere(
      (conv) => 
        conv.participantIds.length == 2 && 
        conv.participantIds.contains(user1Id) && 
        conv.participantIds.contains(user2Id),
      orElse: () => Conversation(
        id: '',
        participantIds: [],
      ),
    );
    
    if (existingConversation.id.isNotEmpty) {
      return existingConversation.id;
    }
    
    // Create a new conversation
    final conversationId = const Uuid().v4();
    final newConversation = Conversation(
      id: conversationId,
      participantIds: [user1Id, user2Id],
      hasUnreadMessages: false,
    );
    
    _conversations[conversationId] = newConversation;
    _messages[conversationId] = [];
    
    _conversationsController.add(_conversations.values.toList());
    return conversationId;
  }

  // Clean up
  void dispose() {
    _conversationsController.close();
    _messagesController.close();
  }
}