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

- **Windows 10/11** with Developer Mode enabled
- **Flutter SDK 3.24.5** or later
- **Android Studio** 2025.1.4 or later
- **Java Development Kit (JDK)** 21 (comes with Android Studio)
- **Firebase account** for backend services
- **Git** for version control

### Step-by-Step Installation Guide

#### 1. **Enable Windows Developer Mode**
   ```powershell
   # Run this command to open Developer Settings
   start ms-settings:developers
   ```
   - In Settings, go to "For developers"
   - Toggle "Developer Mode" to ON
   - This enables symlink support required by Flutter plugins

#### 2. **Install Flutter SDK**
   ```powershell
   # Create Flutter directory
   New-Item -ItemType Directory -Path "C:\flutter" -Force
   
   # Download Flutter SDK (automatically done by setup script)
   # Flutter will be installed at C:\flutter
   ```

   **Add Flutter to PATH:**
   - Open System Environment Variables
   - Add `C:\flutter\bin` to your PATH
   - Restart your terminal

#### 3. **Verify Installation**
   ```bash
   flutter doctor
   ```
   Ensure all checkmarks are green, especially:
   - ✅ Flutter SDK
   - ✅ Android toolchain
   - ✅ Android Studio

#### 4. **Clone and Setup Project**
   ```bash
   git clone <repository-url>
   cd instagram_Clone
   
   # Install Flutter dependencies
   flutter pub get
   ```

#### 5. **Android Studio Setup**
   - Open Android Studio
   - Install Flutter and Dart plugins:
     - Go to File → Settings → Plugins
     - Search and install "Flutter" plugin
     - This will also install the Dart plugin

#### 6. **Create Android Virtual Device (AVD)**
   ```bash
   # List available emulators
   flutter emulators
   
   # Launch emulator (if available)
   flutter emulators --launch <emulator_id>
   
   # Or create a new one in Android Studio:
   # Tools → AVD Manager → Create Virtual Device
   ```

#### 7. **Firebase Configuration**

   **A. Create Firebase Project:**
   - Visit [Firebase Console](https://console.firebase.google.com/)
   - Create new project or use existing
   - Enable the following services:
     - 🔐 Authentication (Email/Password)
     - 🗄️ Cloud Firestore Database  
     - 📁 Cloud Storage
     - 🎯 Realtime Database (optional)

   **B. Add Android App:**
   - In Firebase Console, click "Add app" → Android
   - Use package name: `com.example.instagram_clone`
   - Download `google-services.json`
   - Place it in `android/app/google-services.json`

   **C. Configure Firestore Collections:**
   Create these collections in Firestore:

   ```javascript
   // Collection: users
   {
     "displayName": "John Doe",
     "username": "johndoe123", 
     "email": "john@example.com",
     "photoURL": "https://example.com/profile.jpg"
   }
   
   // Collection: posts  
   {
     "caption": "My awesome post!",
     "username": "johndoe123",
     "profileImageUrl": "https://example.com/profile.jpg",
     "timestamp": "2025-01-13T10:30:00Z"
   }
   ```

#### 8. **Run the Application**
   ```bash
   # Check connected devices
   flutter devices
   
   # Run on Android emulator
   flutter run -d <device_id>
   
   # Or run on all available devices
   flutter run
   ```

### 🔧 Troubleshooting

#### Common Issues and Solutions:

**1. Java/Gradle Compatibility Issues:**
```bash
# If you get Gradle compatibility errors:
flutter clean
flutter pub get

# Ensure you're using compatible versions:
# Java 21 + Gradle 8.4+ + Android Gradle Plugin 8.1.4+
```

**2. Developer Mode Not Enabled:**
```powershell
# Enable Developer Mode
start ms-settings:developers
# Toggle "Developer Mode" to ON
```

**3. Android Licenses Not Accepted:**
```bash
# Accept all Android SDK licenses
flutter doctor --android-licenses
# Type 'y' for all prompts
```

**4. Emulator Not Starting:**
```bash
# List available emulators
flutter emulators

# Create new emulator if none exists
flutter emulators --create

# Or use Android Studio: Tools → AVD Manager
```

**5. Build Failures:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --debug
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

### 🔄 Development Workflow

```bash
# Daily development routine
1. Pull latest changes: git pull origin main
2. Check Flutter setup: flutter doctor
3. Get dependencies: flutter pub get
4. Run app: flutter run -d <device_id>
5. Hot reload: Press 'r' in terminal during development
6. Hot restart: Press 'R' in terminal
7. Quit: Press 'q' in terminal
```

### 📊 Project Status

#### ✅ Completed Features:
- [x] Flutter environment setup
- [x] Firebase integration configuration  
- [x] User authentication (Sign In/Sign Up)
- [x] Custom UI components (buttons, text fields)
- [x] Navigation between screens
- [x] Profile image upload capability
- [x] Firestore database integration
- [x] Home feed structure
- [x] Drawer navigation

#### 🚧 In Progress:
- [ ] Java/Gradle compatibility optimization
- [ ] Image picker functionality refinement
- [ ] Build configuration improvements

#### 📋 Pending Features:
- [ ] Post creation and upload
- [ ] Image filtering and editing
- [ ] Like and comment functionality
- [ ] Real-time feed updates
- [ ] Search functionality
- [ ] Follow/Unfollow system
- [ ] Push notifications
- [ ] Story functionality
- [ ] Direct messaging
- [ ] Dark mode support

### 🎯 Next Steps for Development

1. **Resolve Build Issues**: Fix Java 21/Gradle compatibility
2. **Enable Developer Mode**: For Windows symlink support
3. **Test Basic App**: Ensure sign-in/sign-up works
4. **Implement Image Upload**: Complete post creation flow
5. **Add Social Features**: Like, comment, follow system

## 🐛 Known Issues & Limitations

### Current Technical Issues:
- **Java/Gradle Compatibility**: Project requires Java 21 compatible Gradle setup
- **Windows Developer Mode**: Must be enabled for symlink support
- **Image Picker**: Web platform compatibility issues
- **Build Configuration**: Some Firebase plugins need buildConfig enabled

### Feature Limitations:
- Search screen is placeholder (needs implementation)
- Upload images functionality needs completion  
- Social login buttons need backend integration
- Profile screen needs user data display
- Real-time updates not implemented

### Workarounds:
- Enable Windows Developer Mode before running
- Use Android emulator instead of web for testing
- Accept all Android licenses using `flutter doctor --android-licenses`

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
