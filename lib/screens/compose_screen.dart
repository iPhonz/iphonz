import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/post_service.dart';
import '../services/group_service.dart';
import '../services/user_service.dart';
import '../models/post.dart';
import '../models/group.dart';

class ComposeScreen extends StatefulWidget {
  final String? groupId; // Optional group ID if composing directly for a group

  const ComposeScreen({Key? key, this.groupId}) : super(key: key);

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  final TextEditingController _textController = TextEditingController();
  final int _maxChars = 500;
  Group? _selectedGroup;
  bool _canPost = false;
  final PostService _postService = PostService();
  final GroupService _groupService = GroupService();
  final UserService _userService = UserService();
  
  // Selected media
  String? _selectedMedia;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_updatePostButton);
    
    // If a group ID was provided, set it as the selected group
    if (widget.groupId != null) {
      _selectedGroup = _groupService.getGroupById(widget.groupId!);
    }
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

  // Handle post creation
  void _createPost() {
    if (_canPost) {
      final Post newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        user: _userService.currentUser,
        content: _textController.text,
        imageUrl: _selectedMedia,
        timestamp: DateTime.now(),
        likes: 0,
        comments: 0,
        isJoined: false,
      );
      
      // Add post to the selected group if one is selected
      if (_selectedGroup != null) {
        _groupService.addPostToGroup(_selectedGroup!.id, newPost);
      }
      
      // Add post to the main feed
      _postService.createPost(
        username: _userService.currentUser.username,
        profileImage: _userService.currentUser.profileImage,
        content: _textController.text,
        memeImage: _selectedMedia,
        tagline: '',
      );
      
      Navigator.pop(context);
    }
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

  void _selectMedia(String mediaType) {
    // In a real app, this would open a media picker
    if (mediaType == 'Photo') {
      setState(() {
        _selectedMedia = 'assets/images/thinking_meme.jpg';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo selected')),
      );
    } else if (mediaType == 'Camera') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera would open here')),
      );
    } else if (mediaType == 'GIF') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GIF picker would open here')),
      );
    } else if (mediaType == 'Poll') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Poll creation would open here')),
      );
    } else if (mediaType == 'NSFW') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Content marked as NSFW')),
      );
    }
  }

  void _showGroupSelectionDialog() {
    // Get joined groups for selection
    final joinedGroups = _groupService.getJoinedGroups();
    
    if (joinedGroups.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You haven\'t joined any groups yet'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Group'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: joinedGroups.length,
            itemBuilder: (context, index) {
              final group = joinedGroups[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(group.groupImage),
                ),
                title: Text(group.name),
                subtitle: Text('${group.memberCount} members'),
                selected: _selectedGroup?.id == group.id,
                onTap: () {
                  setState(() {
                    _selectedGroup = group;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedGroup = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Post to My Profile'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
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
              onPressed: _canPost ? _createPost : null,
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
                    backgroundImage: _selectedGroup != null
                        ? AssetImage(_selectedGroup!.groupImage)
                        : AssetImage(_userService.currentUser.profileImage),
                  ),
                  title: Text(
                    _selectedGroup != null
                        ? _selectedGroup!.name
                        : 'Post to My Profile',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_down),
                  onTap: _showGroupSelectionDialog,
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
                          decoration: InputDecoration(
                            hintText: _textController.text.isEmpty 
                                ? "Me: 'I'm going to bed #earlytonight.' Also me at 3 AM: watching a raccoon wash grapes in slow motion" 
                                : "",
                            border: InputBorder.none,
                            counterText: '', // Hide the default counter
                          ),
                          maxLines: null, // Allow multiple lines
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                            return Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '$remainingChars',
                                style: TextStyle(
                                  color: remainingChars < 50 ? Colors.red : Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Selected media preview (if any)
                      if (_selectedMedia != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(_selectedMedia!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedMedia = null;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                      
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
                            _buildMediaButton(Icons.gif_box, 'GIF'),
                            _buildMediaButton(Icons.bar_chart, 'Poll'),
                            GestureDetector(
                              onTap: () => _selectMedia('NSFW'),
                              child: Container(
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
      onPressed: () => _selectMedia(label),
      tooltip: label,
    );
  }
}
