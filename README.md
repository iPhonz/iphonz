# SPILL App Clone

A Flutter implementation of the SPILL social media app based on the provided design.

## Features

- Light pink/purple gradient background with modern UI
- Timeline feed showing posts from users with meme images
- Hashtag highlighting in posts with purple accent color
- Post interactions (share, comment, like)
- "Joined" and "Join" buttons for each post
- Comment section for posts
- Bottom navigation bar with home, notifications, create post, search, and profile
- Purple accent colors throughout the UI
- **Compose functionality** with 500 character limit and media attachments
- **Notifications system** with filtering and approval actions

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

## Project Structure

```
spill_clone/
├── lib/
│   ├── main.dart           # App entry point
│   ├── models/             # Data models
│   │   ├── post.dart           # Post and Comment models
│   │   └── notification_item.dart  # Notification model
│   ├── screens/            # App screens
│   │   ├── home_screen.dart    # Main timeline screen
│   │   ├── compose_screen.dart # Post creation screen
│   │   └── notifications_screen.dart # Notifications screen
│   ├── services/           # Business logic
│   │   ├── post_service.dart   # Post management service
│   │   └── notification_service.dart # Notification management service
│   ├── utils/              # Utilities and constants
│   └── widgets/            # Reusable UI components
│       ├── post_item.dart      # Post card widget
│       └── notification_item_widget.dart # Notification widget
├── assets/                 # Images, fonts, etc.
└── pubspec.yaml            # Project configuration
```

## Screenshots

The app interface matches the provided design with:
- Purple accent colors for buttons and hashtags
- Light pink/purple gradient background
- Meme images in posts
- Comment sections
- Modern engagement buttons
- Compose screen with media attachment options
- Notifications screen with filtering tabs and approval actions

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
