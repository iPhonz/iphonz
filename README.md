# SPILL App Clone

A Flutter implementation of the SPILL social media app based on the provided design.

## Features

- Light pink/purple gradient background with modern UI
- Timeline feed showing posts from users with meme images
- Hashtag highlighting in posts with purple accent color
- Post interactions (share, comment, like)
- "Joined" and "Join" buttons for each post
- Comment section for posts with threaded replies
- Bottom navigation bar with home, notifications, create post, search, and profile
- Purple accent colors throughout the UI
- **Compose functionality** with 500 character limit and media attachments
- **Notifications system** with filtering and approval actions
- **Threaded comments** with support for replies, images, and likes
- **User profiles** with full customization, follows, and post history
- **Groups functionality** with categories, joined groups, and group posts

## Compose Screen Features

- Character counter (up to 500 characters)
- Hashtag highlighting in real-time
- Media attachment options (Photo, Camera, GIF, Poll, NSFW)
- Group selection dropdown
- Purple "Spill" button to submit posts
- Gradient background matching the app theme

## Notifications Screen Features

- Purple gradient background
- Filter tabs for "All", "New", "Friend Requests", "Groups", "Comments"
- Section headers for different notification types
- Unread indicators (blue dots)
- "Approve" buttons for friend and group requests
- Post thumbnails for group posts
- Badge counter on the notifications icon

## Comments Screen Features

- Dark theme with white text
- Support for threaded comments and replies
- Ability to include images in comments
- Like functionality for comments (coffee cup icon)
- Reply button for creating threaded conversations
- Comment input field with user avatar
- Display of like counts and timestamps
- Seamless navigation from posts to comments

## Profile Screen Features

- User profile with banner image and avatar
- Bio, location, website, and pronouns display
- Follow/unfollow functionality
- Following and followers counts
- Join date and user verification badge
- "Edit Profile" button for current user
- Tabbed interface for Posts, Media, and Likes
- Purple accents matching app theme
- Interest tags display
- Direct message option (if enabled by user)

## Groups Screen Features

- "My Groups" and "Explore Groups" tabs
- Group search functionality with real-time filtering
- Category filtering with interactive chips (Music, Pop Culture, News, etc.)
- Group listing with image, name, member count, and new content indicators
- Join/Leave group functionality with instant UI updates
- New content indicators showing unread posts in groups
- Create group feature with category selection
- Group detail view showing members, description, and posts

## Group Detail Screen Features

- Custom collapsing header with group image and information
- About section with group description and category
- Group post feed with context-aware display
- Join/Leave button for membership management
- Post creation specifically for the viewed group
- Member count and activity stats
- Seamless integration with the timeline feed

## Edit Profile Screen Features

- Customizable profile picture and banner image
- Editable name, handle, bio, and location fields
- Pronoun selection
- Website input
- Interest selection with toggle chips
- Privacy settings for direct messages
- Account options for password and email changes

## Project Structure

```
spill_clone/
├── lib/
│   ├── main.dart           # App entry point
│   ├── models/             # Data models
│   │   ├── post.dart           # Post model
│   │   ├── comment.dart        # Comment model with threading support
│   │   ├── notification_item.dart  # Notification model
│   │   ├── group.dart          # Group model with categories
│   │   └── user.dart           # User profile model
│   ├── screens/            # App screens
│   │   ├── home_screen.dart        # Main timeline screen
│   │   ├── compose_screen.dart     # Post creation screen
│   │   ├── notifications_screen.dart # Notifications screen
│   │   ├── comments_screen.dart     # Comments and replies screen
│   │   ├── profile_screen.dart      # User profile screen
│   │   ├── edit_profile_screen.dart # Profile editing screen
│   │   ├── groups_screen.dart       # Groups discovery screen
│   │   ├── group_detail_screen.dart # Individual group screen
│   │   └── create_group_screen.dart # Group creation screen
│   ├── services/           # Business logic
│   │   ├── post_service.dart       # Post management service
│   │   ├── comment_service.dart    # Comment and reply management
│   │   ├── notification_service.dart # Notification management service
│   │   ├── group_service.dart      # Group management service
│   │   └── user_service.dart       # User profile management
│   ├── utils/              # Utilities and constants
│   └── widgets/            # Reusable UI components
│       ├── post_item.dart          # Post card widget
│       ├── comment_item.dart       # Comment and reply widget
│       ├── notification_item_widget.dart # Notification widget
│       ├── group_item.dart         # Group list item widget
│       └── group_category_chip.dart # Category filter widget
├── assets/                 # Images, fonts, etc.
└── pubspec.yaml            # Project configuration
```

## Screenshots

The app interface matches the provided design with:
- Purple accent colors for buttons and hashtags
- Light pink/purple gradient background
- Meme images in posts
- Comment sections with threaded replies
- Modern engagement buttons
- Compose screen with media attachment options
- Notifications screen with filtering tabs and approval actions
- Dark themed comments screen with threaded replies
- User profiles with customizable information and social interactions
- Group browsing and management functionality with categories

## Getting Started

### Prerequisites

- Flutter SDK (2.0 or higher)
- Dart SDK (2.12 or higher)
- Android Studio / VS Code
- Android / iOS emulator or physical device

### Installation

1. Clone this repository
2. Navigate to the project directory
3. Install dependencies: `flutter pub get`
4. Run the app: `flutter run`

## Usage

- Browse posts on the home timeline
- Tap the '+' button in the bottom navigation to create a new post
- Add hashtags by typing '#' followed by text
- Add media by tapping the media buttons at the bottom of the compose screen
- Posts are limited to 500 characters
- Like posts by tapping the coffee icon
- Join/leave groups with the Join/Joined button
- View notifications by tapping the bell icon
- Filter notifications by category using the tabs
- Approve friend requests and group join requests
- View and add comments by tapping the comment bubble icon on posts
- Reply to comments by tapping the "Reply" button
- Like comments by tapping the coffee cup icon
- View user profiles by tapping the profile icon in bottom navigation
- Follow/unfollow users from their profile pages
- Edit your profile by tapping the "Edit Profile" button
- Customize your profile information including bio, location, and interests
- Browse groups by tapping the groups icon in the bottom navigation
- Filter groups by category or search for specific groups
- View joined groups in the "My Groups" tab
- Create a new group by tapping the floating action button in the groups screen
- View group details by tapping on a group
- Post to a specific group by selecting it in the compose screen
