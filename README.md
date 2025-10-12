# 📱 Instagram Clone - LaughFun

A feature-rich Instagram clone built with Flutter and Firebase.

## 🌟 Features

### Authentication

- **Email/Password Sign In** - Secure user authentication with Firebase Auth
- **User Registration** - Complete sign-up flow with profile image upload
- **Social Login Integration** - Google and Apple sign-in buttons (UI ready)
- **Profile Image Upload** - Users can set profile pictures during registration

### Core Functionality

- **Home Feed** - View posts from all users with real-time updates
- **User Profiles** - Dedicated profile screen for user information
- **Post Management** - Fetch and display posts from Firestore database
- **Navigation Drawer** - Easy access to profile and logout functionality

### UI/UX

- **Modern Design** - Instagram-inspired interface with custom styling
- **Custom Components** - Reusable UI elements (buttons, text fields, tiles)
- **Gradient Buttons** - Beautiful purple-pink-orange gradient styling
- **Responsive Layout** - Optimized for various screen sizes
- **Custom Fonts** - Poppins font family for consistent typography

## 🛠️ Tech Stack

- **Framework:** Flutter (SDK >=2.19.6 <3.0.0)
- **Backend:** Firebase Suite
  - Firebase Authentication
  - Cloud Firestore Database
  - Firebase Storage
  - Firebase Core
- **State Management:** StatefulWidget with setState
- **Image Handling:** Image Picker plugin
- **Icons:** Font Awesome Flutter, Cupertino Icons

## 📁 Project Structure

```
lib/
├── Screen/
│   ├── sign_in.dart          # User authentication screen
│   ├── sign_up.dart          # User registration screen
│   ├── home_screen.dart      # Main feed display
│   ├── profile.dart          # User profile screen
│   ├── feed_screen.dart      # Feed management
│   ├── search.dart           # Search functionality
│   └── upload_images.dart    # Image upload feature
├── components/
│   ├── my_button.dart        # Custom gradient button
│   ├── my_textfield.dart     # Custom text input field
│   └── square_tile.dart      # Social login tiles
└── main.dart                 # App entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=2.19.6)
- Dart SDK
- Android Studio / VS Code
- Firebase account
- Android/iOS device or emulator

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd instagram_Clone
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Firebase Setup**

   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password method)
   - Create a Firestore database
   - Enable Firebase Storage
   - Download `google-services.json` and place it in `android/app/`
   - Download `GoogleService-Info.plist` for iOS (if targeting iOS)

4. **Configure Firebase Collections**

   Create these Firestore collections:

   **users collection:**

   ```json
   {
     "displayName": "User Name",
     "username": "username",
     "email": "user@example.com",
     "photoURL": "profile_image_url"
   }
   ```

   **posts collection:**

   ```json
   {
     "caption": "Post caption",
     "username": "poster_username",
     "profileImageUrl": "profile_image_url",
     "timestamp": "post_timestamp"
   }
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 App Flow

1. **Launch** - App starts with the Sign In screen
2. **Authentication** - Users can sign in or navigate to registration
3. **Registration** - New users provide details and upload profile picture
4. **Home Screen** - Authenticated users see the main feed
5. **Navigation** - Access profile and logout via drawer menu

## 🔧 Configuration

### Firebase Security Rules

**Firestore Rules:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null;
    }
    match /posts/{postId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
```

**Storage Rules:**

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /profile_images/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  firebase_database: ^10.2.1
  firebase_auth: ^4.6.1
  firebase_core: ^2.13.0
  firebase_ui_firestore: ^1.5.1
  cloud_firestore: ^4.7.1
  font_awesome_flutter: ^10.4.0
  image_picker: ^0.8.7+5
  firebase_storage: ^11.2.1
```

## 🎨 Design Features

- **Custom Gradient Buttons** - Purple to pink to orange gradient
- **Poppins Font** - Modern typography throughout the app
- **Instagram-like UI** - Familiar interface for users
- **Responsive Design** - Works on various screen sizes
- **Material Design** - Following Flutter's design principles

## 🚧 Future Enhancements

- [ ] Complete image upload and posting functionality
- [ ] Implement like and comment features
- [ ] Add story functionality
- [ ] Implement direct messaging
- [ ] Add push notifications
- [ ] Enhanced search functionality
- [ ] Follow/Unfollow system
- [ ] Real-time feed updates
- [ ] Image filters and editing
- [ ] Dark mode support

## 🐛 Known Issues

- Search screen is placeholder (needs implementation)
- Upload images functionality needs completion
- Social login buttons need backend integration
- Profile screen needs user data display

## 📄 License

This project is developed for educational purposes as part of a Mobile App Development assessment.

## 👨‍💻 Author

**Student Project - Semester 6 Mobile App Development**

---

### 📝 Development Notes

- Built with Flutter framework for cross-platform compatibility
- Utilizes Firebase for backend services and real-time capabilities
- Implements modern mobile app development best practices
- Focuses on user experience and Instagram-like functionality

**Happy Coding! 🚀**
