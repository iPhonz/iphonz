// Update profile_screen.dart to add direct message button
// Add this to the existing profile screen where appropriate

// Inside your profile screen widget
// This is a partial update - assuming the existing profile_screen.dart file

/*
// Inside the profile screen's build method, add this code block to enable messaging
if (widget.user.id != currentUserId && widget.user.allowsMessages) {
  // Add message button
  ElevatedButton.icon(
    onPressed: () {
      final messagingService = Provider.of<MessagingService>(context, listen: false);
      // Create a new conversation or get existing one
      messagingService._getOrCreateConversation(currentUserId, widget.user.id).then((conversationId) {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              otherUser: widget.user,
              conversationId: conversationId,
              messagingService: messagingService,
            ),
          ),
        );
      });
    },
    icon: const Icon(Icons.message),
    label: const Text('Message'),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  )
}
*/
