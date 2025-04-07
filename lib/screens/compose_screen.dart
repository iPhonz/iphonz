import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ComposeScreen extends StatefulWidget {
  const ComposeScreen({Key? key}) : super(key: key);

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  final TextEditingController _textController = TextEditingController();
  final int _maxChars = 500;
  String _selectedGroup = 'Yoga On Mondays';
  bool _canPost = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_updatePostButton);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updatePostButton() {
    setState(() {
      _canPost = _textController.text.trim().isNotEmpty;
    });
  }

  // Convert hashtags to purple color
  Widget _buildRichText(String text) {
    List<TextSpan> spans = [];
    final RegExp hashtagRegExp = RegExp(r'#\w+');
    
    int lastIndex = 0;
    for (Match match in hashtagRegExp.allMatches(text)) {
      // Add text before hashtag
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: const TextStyle(fontSize: 22),
        ));
      }
      
      // Add hashtag with purple color
      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(
          fontSize: 22,
          color: Color(0xFF7941FF),
          fontWeight: FontWeight.bold,
        ),
      ));
      
      lastIndex = match.end;
    }
    
    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: const TextStyle(fontSize: 22),
      ));
    }
    
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 22),
        children: spans,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get remaining character count
    int remainingChars = _maxChars - _textController.text.length;
    
    return Scaffold(
      // Use gradient background
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Compose',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: _canPost ? () {
                // TODO: Implement post functionality
                Navigator.of(context).pop();
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7941FF),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF7941FF).withOpacity(0.5),
                disabledForegroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Spill',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7941FF), // Purple
              Color(0xFFF8B0B0), // Pinkish
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Group selection dropdown
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile1.jpg'),
                  ),
                  title: Text(
                    _selectedGroup,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_down),
                  onTap: () {
                    // TODO: Implement group selection dropdown
                  },
                ),
              ),
              
              // Main compose card
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Text editor
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          maxLength: _maxChars,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          style: const TextStyle(fontSize: 22),
                          decoration: const InputDecoration(
                            hintText: "What's on your mind?",
                            border: InputBorder.none,
                            counterText: '', // Hide the default counter
                          ),
                          maxLines: null, // Allow multiple lines
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                            return Text(
                              '$remainingChars/${_maxChars}',
                              style: TextStyle(
                                color: remainingChars < 50 ? Colors.red : Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Media attachment options
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMediaButton(Icons.photo, 'Photo'),
                            _buildMediaButton(Icons.camera_alt, 'Camera'),
                            _buildMediaButton(Icons.gif, 'GIF'),
                            _buildMediaButton(Icons.bar_chart, 'Poll'),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'NSFW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaButton(IconData icon, String label) {
    return IconButton(
      icon: Icon(icon, color: Colors.black),
      onPressed: () {
        // TODO: Implement media selection
      },
      tooltip: label,
    );
  }
}