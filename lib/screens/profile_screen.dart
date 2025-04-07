import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../services/post_service.dart';
import '../widgets/post_item.dart';
import '../models/post.dart';
import 'edit_profile_screen.dart';
import 'dart:ui';

class ProfileScreen extends StatefulWidget {
  final String? userId; // If null, show current user profile

  const ProfileScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final UserService _userService = UserService();
  final PostService _postService = PostService();
  late User _user;
  List<Post> _userPosts = [];
  bool _isCurrentUser = false;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserData();
    _userService.addListener(_refreshUserData);
    _postService.addListener(_refreshUserPosts);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _userService.removeListener(_refreshUserData);
    _postService.removeListener(_refreshUserPosts);
    super.dispose();
  }

  void _loadUserData() {
    if (widget.userId == null) {
      // Current user profile
      _user = _userService.currentUser;
      _isCurrentUser = true;
    } else {
      // Other user's profile
      _user = _userService.getUserById(widget.userId!) ?? _userService.currentUser;
      _isCurrentUser = _user.id == _userService.currentUser.id;
      _isFollowing = _userService.currentUser.following.contains(_user.id);
    }
    
    _loadUserPosts();
  }

  void _refreshUserData() {
    setState(() {
      _loadUserData();
    });
  }

  void _loadUserPosts() {
    _userPosts = _postService.getPosts().where((post) => 
      _user.postIds.contains(post.id)).toList();
  }

  void _refreshUserPosts() {
    setState(() {
      _loadUserPosts();
    });
  }

  void _toggleFollow() {
    if (_isFollowing) {
      _userService.unfollowUser(_user.id);
    } else {
      _userService.followUser(_user.id);
    }
    
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    ).then((_) {
      // Refresh user data when returning from edit profile
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final followers = _user.followers.length;
    final following = _user.following.length;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8E4E8), // Light pink background
      body: CustomScrollView(
        slivers: [
          // Banner with blurred image and profile photo 
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              // Message button if not current user and allows messages
              if (!_isCurrentUser && _user.allowsMessages)
                IconButton(
                  icon: const Icon(Icons.message_outlined, color: Colors.white),
                  onPressed: () {
                    // TODO: Navigate to messaging screen
                  },
                ),
              // More options button
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  // TODO: Show more options 
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Banner image (blurred if not available)
                  _user.bannerImage.isNotEmpty 
                    ? Image.asset(
                        _user.bannerImage,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        // Gradient background if no banner
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF7941FF).withOpacity(0.3),
                              Color(0xFFAB65F0).withOpacity(0.2),
                            ],
                          ),
                        ),
                      ),
                  // Blur overlay for visual effect
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Profile header with photo, name, bio
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // White container for content
                Container(
                  padding: const EdgeInsets.only(top: 50, bottom: 15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Follow/Edit button 
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.only(right: 20, top: 10),
                          child: _isCurrentUser
                            ? OutlinedButton(
                                onPressed: _navigateToEditProfile,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Color(0xFF7941FF),
                                  side: BorderSide(color: Color(0xFF7941FF)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('Edit Profile'),
                              )
                            : ElevatedButton(
                                onPressed: _toggleFollow,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isFollowing 
                                    ? Colors.white 
                                    : Color(0xFF7941FF),
                                  foregroundColor: _isFollowing 
                                    ? Color(0xFF7941FF) 
                                    : Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: Color(0xFF7941FF), 
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Text(_isFollowing ? 'Following' : 'Follow'),
                              ),
                        ),
                      ),
                      
                      // Name, handle, verification badge
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Row(
                          children: [
                            Text(
                              _user.displayName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            if (_user.isVerified)
                              const Icon(
                                Icons.verified,
                                color: Color(0xFF7941FF),
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                      
                      // Handle and pronouns
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: [
                            Text(
                              _user.handle,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            if (_user.pronouns.isNotEmpty) ...[
                              const SizedBox(width: 5),
                              Text(
                                _user.pronouns,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      // Bio
                      if (_user.bio.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: Text(
                            _user.bio,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      
                      // Location, website, and join date
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 5,
                          children: [
                            if (_user.location.isNotEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.location_on_outlined, 
                                    color: Colors.grey, size: 16),
                                  const SizedBox(width: 2),
                                  Text(
                                    _user.location,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            if (_user.website.isNotEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.link, 
                                    color: Colors.grey, size: 16),
                                  const SizedBox(width: 2),
                                  Text(
                                    _user.website,
                                    style: const TextStyle(
                                      color: Color(0xFF7941FF),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.calendar_today, 
                                  color: Colors.grey, size: 16),
                                const SizedBox(width: 2),
                                Text(
                                  'Joined ${_user.joinDate}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            if (_user.userTag.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE6DCFF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _user.userTag,
                                  style: const TextStyle(
                                    color: Color(0xFF7941FF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // Followers/Following count
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // TODO: Navigate to following screen
                              },
                              child: Row(
                                children: [
                                  Text(
                                    '$following',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    'Following',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                // TODO: Navigate to followers screen
                              },
                              child: Row(
                                children: [
                                  Text(
                                    '$followers',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    'Followers',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Profile photo - positioned with top and left values instead of negative margin
                Positioned(
                  top: -50,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 4),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(_user.profileImage),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Tab bar for Posts, Media, Likes
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF7941FF),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF7941FF),
                tabs: const [
                  Tab(text: 'Posts'),
                  Tab(text: 'Media'),
                  Tab(text: 'Likes'),
                ],
              ),
            ),
          ),
          
          // Tab bar content - Posts, Media, and Likes tabs
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Posts tab
                _userPosts.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                          'No posts yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _userPosts.length,
                      itemBuilder: (context, index) {
                        return PostItem(
                          post: _userPosts[index],
                          onLike: () => _postService.likePost(
                            _postService.getPosts().indexOf(_userPosts[index])
                          ),
                          onToggleJoin: () => _postService.toggleJoin(
                            _postService.getPosts().indexOf(_userPosts[index])
                          ),
                        );
                      },
                    ),
                
                // Media tab
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 50,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'No media posts yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Likes tab
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.coffee_outlined,
                          size: 50,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'No liked posts yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
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
}

// Delegate for the sliver persistent header with tab bar
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
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

// Profile section header component
class _ProfileSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final String buttonLabel;

  const _ProfileSectionHeader({
    required this.title,
    this.onPressed,
    this.buttonLabel = 'See all',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onPressed != null)
            TextButton(
              onPressed: onPressed,
              child: Text(
                buttonLabel,
                style: const TextStyle(
                  color: Color(0xFF7941FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Interests section with horizontal scrolling
class _InterestsSection extends StatelessWidget {
  final List<String> interests;

  const _InterestsSection({required this.interests});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ProfileSectionHeader(title: 'Interests'),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: interests.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6DCFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  interests[index],
                  style: const TextStyle(
                    color: Color(0xFF7941FF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}