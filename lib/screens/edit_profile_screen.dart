import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserService _userService = UserService();
  late User _user;
  
  // Text controllers for text fields
  late TextEditingController _nameController;
  late TextEditingController _handleController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late TextEditingController _websiteController;
  late TextEditingController _pronounsController;
  
  // Selected interests
  late List<String> _selectedInterests;
  
  // Messages permission
  late bool _allowMessages;

  @override
  void initState() {
    super.initState();
    _user = _userService.currentUser;
    
    // Initialize controllers with current values
    _nameController = TextEditingController(text: _user.displayName);
    _handleController = TextEditingController(text: _user.handle);
    _bioController = TextEditingController(text: _user.bio);
    _locationController = TextEditingController(text: _user.location);
    _websiteController = TextEditingController(text: _user.website);
    _pronounsController = TextEditingController(text: _user.pronouns);
    
    // Initialize selected interests
    _selectedInterests = List.from(_user.interests);
    
    // Initialize messages permission
    _allowMessages = _user.allowsMessages;
  }

  @override
  void dispose() {
    // Dispose all controllers
    _nameController.dispose();
    _handleController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _pronounsController.dispose();
    super.dispose();
  }

  // Save profile changes
  void _saveProfile() {
    _userService.updateProfile(
      displayName: _nameController.text,
      handle: _handleController.text,
      bio: _bioController.text,
      location: _locationController.text,
      website: _websiteController.text,
      pronouns: _pronounsController.text,
      interests: _selectedInterests,
      allowsMessages: _allowMessages,
    );
    
    // Show success message and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
    Navigator.pop(context);
  }

  // Toggle interest selection
  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E4E8),
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF7941FF),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile banner and photo
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Banner image
                Container(
                  height: 150,
                  width: double.infinity,
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
                  child: Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        // TODO: Implement banner image picking
                      },
                    ),
                  ),
                ),
                
                // Profile photo
                Positioned(
                  left: 20,
                  bottom: -50,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Implement profile image picking
                    },
                    child: Stack(
                      children: [
                        // Profile image
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(_user.profileImage),
                          ),
                        ),
                        // Camera icon overlay
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF7941FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Form fields (with padding to account for profile image)
            Container(
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name field
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    hintText: 'Your display name',
                    maxLength: 50,
                  ),
                  
                  // Handle field
                  _buildTextField(
                    controller: _handleController,
                    label: 'Handle',
                    hintText: '@username',
                    maxLength: 30,
                    prefixText: '@',
                  ),
                  
                  // Pronouns field
                  _buildTextField(
                    controller: _pronounsController,
                    label: 'Pronouns',
                    hintText: 'Your pronouns (optional)',
                    maxLength: 30,
                  ),
                  
                  // Bio field
                  _buildTextField(
                    controller: _bioController,
                    label: 'Bio',
                    hintText: 'Tell us about yourself',
                    maxLength: 160,
                    maxLines: 4,
                  ),
                  
                  // Location field
                  _buildTextField(
                    controller: _locationController,
                    label: 'Location',
                    hintText: 'Your location (optional)',
                    maxLength: 30,
                    prefixIcon: Icons.location_on_outlined,
                  ),
                  
                  // Website field
                  _buildTextField(
                    controller: _websiteController,
                    label: 'Website',
                    hintText: 'Your website (optional)',
                    maxLength: 100,
                    prefixIcon: Icons.link,
                  ),
                  
                  // Interests section
                  const SizedBox(height: 20),
                  const Text(
                    'Interests',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Interest chips
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      'Music',
                      'Politics',
                      'Fashion',
                      'Art',
                      'Technology',
                      'Sports',
                      'Movies',
                      'Gaming',
                      'Food',
                      'Travel',
                      'Books',
                      'Photography',
                      'Pop Culture',
                      'Beyonce',
                    ].map((interest) => _buildInterestChip(interest)).toList(),
                  ),
                  
                  // Privacy section
                  const SizedBox(height: 30),
                  const Text(
                    'Privacy',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Allow messages toggle
                  SwitchListTile(
                    title: const Text('Allow direct messages'),
                    subtitle: const Text(
                      'Let others message you directly',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    value: _allowMessages,
                    activeColor: const Color(0xFF7941FF),
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      setState(() {
                        _allowMessages = value;
                      });
                    },
                  ),
                  
                  // Account section (for future implementation)
                  const SizedBox(height: 30),
                  const Text(
                    'Account',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Account options
                  _buildAccountOption(
                    icon: Icons.lock_outlined,
                    title: 'Change Password',
                    onTap: () {
                      // TODO: Implement password change
                    },
                  ),
                  _buildAccountOption(
                    icon: Icons.email_outlined,
                    title: 'Change Email',
                    onTap: () {
                      // TODO: Implement email change
                    },
                  ),
                  _buildAccountOption(
                    icon: Icons.logout,
                    title: 'Log Out',
                    titleColor: Colors.red,
                    onTap: () {
                      // TODO: Implement logout
                    },
                  ),
                  
                  // Bottom padding
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int maxLength = 100,
    int maxLines = 1,
    String? prefixText,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            prefixText: prefixText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.grey, size: 20)
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  // Helper method to build interest chips
  Widget _buildInterestChip(String interest) {
    final isSelected = _selectedInterests.contains(interest);
    
    return GestureDetector(
      onTap: () => _toggleInterest(interest),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF7941FF)
              : const Color(0xFFE6DCFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          interest,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF7941FF),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Helper method to build account options
  Widget _buildAccountOption({
    required IconData icon,
    required String title,
    Color titleColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: titleColor),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}