import 'package:flutter/material.dart';
import '../models/group.dart';
import '../models/post.dart';
import '../services/group_service.dart';
import '../widgets/post_item.dart';
import 'compose_screen.dart';

class GroupDetailScreen extends StatefulWidget {
  final Group group;

  const GroupDetailScreen({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  late Group _group;
  final GroupService _groupService = GroupService();

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    _groupService.addListener(_refreshGroup);
  }

  @override
  void dispose() {
    _groupService.removeListener(_refreshGroup);
    super.dispose();
  }

  void _refreshGroup() {
    setState(() {
      _group = _groupService.getGroupById(_group.id);
    });
  }

  void _toggleJoinGroup() {
    _groupService.toggleJoinGroup(_group.id);
  }

  void _navigateToComposeForGroup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComposeScreen(groupId: _group.id),
      ),
    ).then((_) => _refreshGroup());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with gradient and group info
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurple.shade500,
                      Colors.purple.shade300,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(_group.groupImage),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _group.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_group.memberCount} Members',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              collapseMode: CollapseMode.parallax,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              // Join/Leave button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _toggleJoinGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _group.isJoined
                        ? Colors.grey[200]
                        : Colors.white,
                    foregroundColor: _group.isJoined
                        ? Colors.black
                        : const Color(0xFF7941FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _group.isJoined ? 'Joined' : 'Join',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Group description
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _group.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        _group.category.icon,
                        size: 20,
                        color: const Color(0xFF7941FF),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _group.category.displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF7941FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Divider
          const SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 1),
          ),
          
          // Group posts header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Group Spills',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // Posts list
          _group.posts.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.post_add,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No posts in this group yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_group.isJoined)
                          TextButton.icon(
                            onPressed: _navigateToComposeForGroup,
                            icon: const Icon(Icons.add),
                            label: const Text('Create First Post'),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF7941FF),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = _group.posts[index];
                      return PostItem(
                        post: post,
                        onLike: () {},
                        onToggleJoin: () {},
                        showJoinButton: false,
                      );
                    },
                    childCount: _group.posts.length,
                  ),
                ),
        ],
      ),
      floatingActionButton: _group.isJoined
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF7941FF),
              onPressed: _navigateToComposeForGroup,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
