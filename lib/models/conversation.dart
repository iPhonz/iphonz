class Conversation {
  final String id;
  final List<String> participantIds;
  final String? lastMessageContent;
  final DateTime? lastMessageTimestamp;
  final bool hasUnreadMessages;
  
  Conversation({
    required this.id,
    required this.participantIds,
    this.lastMessageContent,
    this.lastMessageTimestamp,
    this.hasUnreadMessages = false,
  });

  Conversation copyWith({
    String? id,
    List<String>? participantIds,
    String? lastMessageContent,
    DateTime? lastMessageTimestamp,
    bool? hasUnreadMessages,
  }) {
    return Conversation(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      hasUnreadMessages: hasUnreadMessages ?? this.hasUnreadMessages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participantIds': participantIds,
      'lastMessageContent': lastMessageContent,
      'lastMessageTimestamp': lastMessageTimestamp?.toIso8601String(),
      'hasUnreadMessages': hasUnreadMessages,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'],
      participantIds: List<String>.from(map['participantIds']),
      lastMessageContent: map['lastMessageContent'],
      lastMessageTimestamp: map['lastMessageTimestamp'] != null
          ? DateTime.parse(map['lastMessageTimestamp'])
          : null,
      hasUnreadMessages: map['hasUnreadMessages'] ?? false,
    );
  }
}