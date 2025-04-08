import 'package:flutter/material.dart';
import '../models/group.dart';
import '../services/group_service.dart';
import '../utils/app_theme.dart';
import '../widgets/group_item.dart';
import '../widgets/group_category_chip.dart';
import 'group_detail_screen.dart';
import 'create_group_screen.dart';

class GroupsScreen extends StatefulWidget {
  // Added showBackButton parameter to control whether to show the back button
  final bool showBackButton;
  
  const GroupsScreen({Key? key, this.showBackButton = false}) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> with SingleTickerProviderStateMixin {
  final GroupService _groupService = GroupService();
  late TabController _tabController;
  List<GroupCategory> _selectedCategories = [];
  List<Group> _filteredGroups = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _filteredGroups = _groupService.getGroups();
    _groupService.addListener(_refreshGroups);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _groupService.removeListener(_refreshGroups);
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedCategories = [];
        _filterGroups();
      });
    }
  }

  void _refreshGroups() {
    setState(() {
      _filterGroups();
    });
  }

  void _filterGroups() {
    List<Group> groups;
    
    // First, determine if we're looking at all groups or just joined groups
    if (_tabController.index == 0) {
      groups = _groupService.getGroups();
    } else {
      groups = _groupService.getJoinedGroups();
    }
    
    // Then apply category filters if any
    if (_selectedCategories.isNotEmpty) {
      groups = groups.where((group) => 
        _selectedCategories.contains(group.category)).toList();
    }
    
    // Finally, apply search filter if any
    if (_searchQuery.isNotEmpty) {
      groups = groups.where((group) => 
        group.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        group.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    
    setState(() {
      _filteredGroups = groups;
    });
  }

  void _toggleCategoryFilter(GroupCategory category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
      _filterGroups();
    });
  }

  void _navigateToGroupDetail(Group group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupDetailScreen(group: group),
      ),
    ).then((_) => _refreshGroups());
  }

  void _navigateToCreateGroup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateGroupScreen(),
      ),
    ).then((_) => _refreshGroups());
  }

  void _toggleJoinGroup(String groupId) {
    _groupService.toggleJoinGroup(groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        // Only show back button if showBackButton is true
        leading: widget.showBackButton ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ) : null,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: const InputDecoration(
                  hintText: 'What are you interested in?',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _filterGroups();
                  });
                },
              )
            : const Text('Groups', style: TextStyle(color: Colors.white, fontSize: 24)),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (_isSearching) {
                  _searchFocusNode.requestFocus();
                } else {
                  _searchQuery = '';
                  _searchController.clear();
                  _filterGroups();
                }
              });
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Explore Groups'),
            Tab(text: 'My Groups'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Category filter chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('Search by Group type',
                      style: TextStyle(
                          color: Colors.grey[700], fontWeight: FontWeight.w500)),
                  const SizedBox(width: 16),
                  ...GroupCategory.values
                      .take(10) // Take the first 10 categories for the demo
                      .map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GroupCategoryChip(
                        category: category,
                        isSelected: _selectedCategories.contains(category),
                        onTap: () => _toggleCategoryFilter(category),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          
          // Group lists with tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Explore Groups Tab
                _buildGroupList(context, false),
                
                // My Groups Tab
                _buildGroupList(context, true),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.purpleAccent,
        onPressed: _navigateToCreateGroup,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildGroupList(BuildContext context, bool myGroupsOnly) {
    List<Group> displayGroups = myGroupsOnly
        ? _groupService.getJoinedGroups()
        : _filteredGroups;

    if (_selectedCategories.isNotEmpty) {
      displayGroups = displayGroups
          .where((group) => _selectedCategories.contains(group.category))
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      displayGroups = displayGroups
          .where((group) =>
              group.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              group.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (displayGroups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              myGroupsOnly
                  ? 'You haven\'t joined any groups yet'
                  : 'No groups found matching your criteria',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedCategories = [];
                  _searchQuery = '';
                  _searchController.clear();
                  _filterGroups();
                });
              },
              child: const Text(
                'Clear filters',
                style: TextStyle(
                  color: AppTheme.purpleAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        if (!myGroupsOnly)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              displayGroups.isEmpty
                  ? 'No groups found'
                  : 'Showing ${displayGroups.length} groups',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        
        // My Groups section
        if (myGroupsOnly)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'My Groups',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        
        ...displayGroups.map((group) => GroupItem(
              group: group,
              onToggleJoin: () => _toggleJoinGroup(group.id),
              onTap: () => _navigateToGroupDetail(group),
            )),
        
        if (!myGroupsOnly && displayGroups.length >= 3)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'See More Groups',
                  style: TextStyle(
                    color: AppTheme.purpleAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}