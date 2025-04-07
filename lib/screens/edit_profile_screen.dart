import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _handleController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late TextEditingController _websiteController;
  late String _selectedPronouns;
  late List<String> _selectedInterests;
  late bool _allowsMessages;
  
  final List<String> _pronounOptions = [
    'he/him',
    'she/her',
    'they/them',
    'he/they',
    'she/they',
    'Other',
    'Prefer not to say',
  ];
  
  final List<String> _interestOptions = [
    'Music',
    'Pop Culture',
    'News',
    'Politics',
    'Sports',
    'Gaming',
    'Technology',
    'Art',
    'Fashion',
    'Food',
    'Travel',
    'Fitness',
    'Movies',
    'TV Shows',
    'Books',
    'Beyonce',
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with user data
    _nameController = TextEditingController(text: widget.user.displayName);
    _handleController = TextEditingController(text: widget.user.handle);
    _bioController = TextEditingController(text: widget.user.bio);
    _locationController = TextEditingController(text: widget.user.location);
    _websiteController = TextEditingController(text: widget.user.website);
    
    _selectedPronouns = widget.user.pronouns;
    _selectedInterests = List.from(widget.user.interests);
    _allowsMessages = widget.user.allowsMessages;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _handleController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // Get user service
    final userService = Provider.of<UserService>(context, listen: false);
    
    // Update profile
    userService.updateProfile(
      displayName: _nameController.text,
      handle: _handleController.text,
      bio: _bioController.text,
      location: _locationController.text,
      website: _websiteController.text,
      pronouns: _selectedPronouns,
      interests: _selectedInterests,
      allowsMessages: _allowsMessages,
    );
    
    // Go back to profile screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBannerAndProfileImage(),
            _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerAndProfileImage() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Banner image
        GestureDetector(
          onTap: () {
            // TODO: Implement banner image selection
          },
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  widget.user.bannerImage.isEmpty
                      ? 'assets/images/default_banner.jpg'
                      : widget.user.bannerImage,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Profile image
        Positioned(
          left: 16,
          bottom: -50,
          child: GestureDetector(
            onTap: () {
              // TODO: Implement profile image selection
            },
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(widget.user.profileImage),
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black.withOpacity(0.3),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('Name', _nameController),
          _buildTextField('Handle', _handleController),
          _buildTextField('Bio', _bioController, maxLines: 3),
          _buildTextField('Location', _locationController),
          _buildTextField('Website', _websiteController),
          _buildPronounsSelector(),
          _buildInterestsSelector(),
          _buildPrivacySettings(),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildPronounsSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pronouns',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _pronounOptions.map((pronoun) {
              final isSelected = _selectedPronouns == pronoun;
              return ChoiceChip(
                label: Text(pronoun),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedPronouns = pronoun;
                    });
                  }
                },
                backgroundColor: Colors.grey[200],
                selectedColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.black,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interests',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _interestOptions.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedInterests.add(interest);
                    } else {
                      _selectedInterests.remove(interest);
                    }
                  });
                },
                backgroundColor: Colors.grey[200],
                selectedColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.black,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettings() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Privacy',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Allow direct messages'),
            subtitle: const Text('Let others send you private messages'),
            value: _allowsMessages,
            onChanged: (value) {
              setState(() {
                _allowsMessages = value;
              });
            },
            activeColor: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}