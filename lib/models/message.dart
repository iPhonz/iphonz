import 'package:flutter/foundation.dart';

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String conversationId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final String? mediaUrl;
  final MessageType type;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.conversationId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.mediaUrl,
    this.type = MessageType.text,
  });

  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? conversationId,
    String? content,
    DateTime? timestamp,
    bool? isRead,
    String? mediaUrl,
    MessageType? type,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'conversationId': conversationId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'mediaUrl': mediaUrl,
      'type': describeEnum(type),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      conversationId: map['conversationId'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
      isRead: map['isRead'] ?? false,
      mediaUrl: map['mediaUrl'],
      type: MessageType.values.firstWhere(
        (e) => describeEnum(e) == map['type'],
        orElse: () => MessageType.text,
      ),
    );
  }
}

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
}