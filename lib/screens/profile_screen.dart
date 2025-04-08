import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../services/messaging_service.dart';
import 'messaging/chat_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  User? _user;
  bool _isLoading = true;
  bool _isFollowing = false;
  bool _isCurrentUser = false;
  String? _currentUserId;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUser();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _loadUser() async {
    final userService = Provider.of<UserService>(context, listen: false);
    
    _currentUserId = userService.getCurrentUserId();
    _isCurrentUser = widget.userId == _currentUserId;
    
    // Get user
    final user = userService.getUserById(widget.userId);
    
    // Check if current user is following this user
    final isFollowing = _isCurrentUser ? false : userService.isFollowing(widget.userId);
    
    setState(() {
      _user = user;
      _isFollowing = isFollowing;
      _isLoading = false;
    });
  }
  
  void _toggleFollow() {
    if (_user == null || _isCurrentUser) return;
    
    final userService = Provider.of<UserService>(context, listen: false);
    
    setState(() {
      if (_isFollowing) {
        userService.unfollowUser(_user!.id);
      } else {
        userService.followUser(_user!.id);
      }
      _isFollowing = !_isFollowing;
    });
  }
  
  void _editProfile() {
    if (_user == null || !_isCurrentUser) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(user: _user!),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? const Center(child: Text('User not found'))
              : _buildProfileContent(),
    );
  }
  
  Widget _buildProfileContent() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfo(),
              _buildBio(),
              _buildStats(),
              _buildActionButtons(),
              _buildInterestTags(),
            ],
          ),
        ),
        _buildTabBar(),
        _buildTabContent(),
      ],
    );
  }
  
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Banner image
            Container(
              height: 200,
              width: double.infinity,
              child: Image.asset(
                _user!.bannerImage.isEmpty ? 'assets/images/default_banner.jpg' : _user!.bannerImage,
                fit: BoxFit.cover,
              ),
            ),
            // Gradient overlay
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Profile image
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(_user!.profileImage),
          ),
          const SizedBox(width: 16),
          // Name and handle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _user!.displayName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_user!.isVerified)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.verified,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ),
                      ),
                  ],
                ),
                Text(
                  _user!.handle.isEmpty ? '@${_user!.username}' : _user!.handle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                if (_user!.pronouns.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _user!.pronouns,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
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
  
  Widget _buildBio() {
    if (_user!.bio == null || _user!.bio!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        _user!.bio!,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
  
  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Location
          if (_user!.location.isNotEmpty)
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _user!.location,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
              ],
            ),
          
          // Website
          if (_user!.website.isNotEmpty)
            Row(
              children: [
                Icon(Icons.link, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _user!.website,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          
          // Join date
          if (_user!.joinDate != null)
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Joined ${_formatDate(_user!.joinDate!)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
        ],
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
  
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Follow/Unfollow button
          if (!_isCurrentUser)
            Expanded(
              child: ElevatedButton(
                onPressed: _toggleFollow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFollowing
                      ? Colors.white
                      : Theme.of(context).colorScheme.secondary,
                  foregroundColor: _isFollowing
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.white,
                  side: _isFollowing
                      ? BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1,
                        )
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(_isFollowing ? 'Following' : 'Follow'),
              ),
            ),
          
          // Edit profile button
          if (_isCurrentUser)
            Expanded(
              child: ElevatedButton(
                onPressed: _editProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Edit Profile'),
              ),
            ),
          
          // Message button
          if (!_isCurrentUser && _user!.allowsMessages)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  final messagingService = Provider.of<MessagingService>(context, listen: false);
                  // Create a new conversation or get existing one
                  // Updated to use the public method instead of the private one
                  messagingService.getOrCreateConversation(_currentUserId!, _user!.id).then((conversationId) {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          otherUser: _user!,
                          conversationId: conversationId,
                          messagingService: messagingService,
                        ),
                      ),
                    );
                  });
                },
                icon: const Icon(Icons.message, size: 18),
                label: const Text('Message'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildInterestTags() {
    if (_user!.interests.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _user!.interests.map((interest) {
          return Chip(
            label: Text(interest),
            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.secondary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          tabs: const [
            Tab(text: 'Posts'),
            Tab(text: 'Media'),
            Tab(text: 'Likes'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTabContent() {
    return SliverFillRemaining(
      child: TabBarView(
        controller: _tabController,
        children: [
          // Posts tab
          Center(child: Text('Posts tab - ${_user!.postIds.length} posts')),
          
          // Media tab
          const Center(child: Text('Media tab')),
          
          // Likes tab
          const Center(child: Text('Likes tab')),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  
  _SliverAppBarDelegate(this._tabBar);
  
  @override
  double get minExtent => _tabBar.preferredSize.height;
  
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }
  
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}