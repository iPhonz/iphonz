# SPILL App Changelog

This document tracks changes made to the SPILL app clone.

## [1.0.1] - 2025-04-07

### UI Improvements
- Removed redundant group icon from the top app bar
- Consolidated group navigation to use only the dedicated icon in the bottom navigation bar
- Improved visual clarity by reducing duplicate UI elements
- Group navigation now exclusively uses the bottom bar icon, which is more consistent with modern mobile UI patterns

### Technical Changes
- Updated `lib/screens/home_screen.dart` to remove the group icon widget from the AppBar's actions
- Maintained all group-related functionality through the bottom navigation bar
- Preserved the unread group notification counter functionality
- Updated README.md to reflect these changes

## [1.0.0] - Initial Release

### Features
- Light pink/purple gradient background with modern UI
- Timeline feed showing posts from users with meme images
- Hashtag highlighting in posts with purple accent color
- Post interactions (share, comment, like)
- "Joined" and "Join" buttons for each post
- Comment section for posts with threaded replies
- Bottom navigation bar with home, notifications, create post, search, and profile
- Purple accent colors throughout the UI
- Compose functionality with 500 character limit and media attachments
- Notifications system with filtering and approval actions
- Threaded comments with support for replies, images, and likes
- User profiles with full customization, follows, and post history
- Groups functionality with categories, joined groups, and group posts
