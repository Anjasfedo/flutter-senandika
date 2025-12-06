# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Senandika is a Flutter-based mental health and wellness application with mood tracking, journaling, meditation, and chat features. The app uses PocketBase as its backend and follows Clean Architecture principles with GetX for state management.

## Development Commands

```bash
# Build APK for production
flutter build apk --target-platform android-arm64 --analyze-size

# Run the app in debug mode
flutter run

# Run on specific device
flutter run -d <device_id>

# Analyze code for issues
flutter analyze

# Get dependencies
flutter pub get

# Clean build cache
flutter clean

# Generate app icons (if needed)
flutter pub run flutter_launcher_icons:main
```

## Architecture Overview

### Clean Architecture with GetX

The codebase follows Clean Architecture principles with these key layers:

```
lib/
├── data/
│   ├── models/         # Data models (UserModel, MoodLogModel, etc.)
│   ├── repositories/   # Repository implementations with abstract interfaces
│   └── sources/       # Data sources (PocketBaseService)
├── services/           # App services (LocalStorageService)
├── constants/         # App constants (colors, routes, API endpoints)
├── routes/           # Route configuration and middleware
└── presentations/
    ├── bindings/      # GetX dependency injection bindings
    ├── controllers/   # GetX controllers extending GetxController
    ├── pages/
    │   ├── auth/      # Authentication pages (login, signup, verification)
    │   ├── protected/ # Authenticated pages (home, journal, meditation, etc.)
    │   └── public/    # Public pages (onboarding)
    └── widgets/       # Reusable widgets
```

### Key Architectural Patterns

1. **GetX State Management**
   - Controllers extend `GetxController` and use reactive variables with `.obs`
   - Dependency injection via Bindings implementing `Bindings` interface
   - Navigation using `Get.toNamed()`, `Get.offAllNamed()`, and route constants
   - Middleware for route protection and authentication checks

2. **Repository Pattern**
   - Abstract interfaces (e.g., `IAuthRepository`, `IJournalRepository`)
   - Concrete implementations using PocketBase with centralized error handling
   - Custom Indonesian error messages for user-friendly feedback

3. **Authentication Flow**
   - Onboarding → Login/Signup → Email Verification → Main App
   - Google OAuth2 integration via url_launcher
   - Custom `AuthMiddleware` protecting routes requiring email verification

### Backend Integration

**PocketBase Configuration:**
- Server: `https://senandika.rafflesiaagro.com`
- Collections: users, mood_logs, emergency_contacts, target_habits, chat_sessions
- Authentication via email/password and Google OAuth2
- Real-time data sync and offline capabilities

### Key Dependencies and Their Uses

- `get: ^4.7.3` - State management, dependency injection, navigation
- `pocketbase: ^0.23.0+1` - Backend SDK for data operations
- `google_fonts: ^6.3.2` - Typography throughout the app
- `shared_preferences: ^2.5.3` - Local storage for app state and preferences
- `url_launcher: ^6.3.2` - OAuth2 redirect handling and external links
- `image_picker: ^1.2.1` - Profile picture selection
- `http: ^1.6.0` - HTTP requests for API calls

### Navigation Structure

**Route Categories:**
- `public/`: splash, onboarding, auth pages (no authentication required)
- `protected/`: main app features (authentication + email verification required)
- `nested/`: sub-pages like chat sessions, profile edit, journal detail

**Key Routes:**
- `/splash` → `/onboarding` → `/login` → `/home`
- Protected routes include `/home`, `/journal`, `/meditation`, `/chat`, `/profile`
- All protected routes are intercepted by `AuthMiddleware`

### Development Patterns

1. **Controller Lifecycle**
   - Implement `onInit()` for initialization
   - Implement `onClose()` for resource cleanup
   - Use `Worker` and `Ever` for reactive listeners when needed

2. **Repository Usage**
   - Always work with interfaces (`IRepository`) for dependency injection
   - Handle errors at the repository layer with user-friendly Indonesian messages
   - Use the provided `PocketBaseService.handleApiCall()` for consistent error handling

3. **State Management**
   - Use `Rx` types for reactive state (`.obs`)
   - Wrap UI components with `Obx()` or `GetBuilder()` for reactivity
   - Dispose controllers properly to prevent memory leaks

4. **Localization Notes**
   - Mix of Indonesian and English in the codebase
   - Error messages are in Indonesian for user-friendliness
   - UI text tends to be in Indonesian, comments in English

### Common Implementation Patterns

**Creating New Features:**
1. Define model classes in `data/models/`
2. Create repository interface in `data/repositories/`
3. Implement repository with PocketBase
4. Create controller extending `GetxController`
5. Create binding for dependency injection
6. Add route to `constants/route_constant.dart`
7. Create pages in appropriate folder
8. Update middleware if route protection is needed

**Navigation Pattern:**
```dart
// Navigate to new page
Get.toNamed(RouteConstants.page_name);

// Navigate with arguments
Get.toNamed(RouteConstants.page_name, arguments: data);

// Navigate and replace current
Get.offNamed(RouteConstants.page_name);

// Navigate to home and clear stack
Get.offAllNamed(RouteConstants.home);
```

**Repository Pattern:**
```dart
// Interface
abstract class IFeatureRepository {
  Future<DataModel> getData();
}

// Implementation
class FeatureRepository implements IFeatureRepository {
  final PocketBaseService _pbService;

  FeatureRepository(this._pbService);

  @override
  Future<DataModel> getData() async {
    return _pbService.handleApiCall(() async {
      // PocketBase operation
    });
  }
}
```

### Color Scheme and Theming

The app uses a calming color palette defined in `constants/color_constant.dart`:
- Primary colors focus on lavender, peach, and green tones
- Consistent use of these colors across all UI components
- Dark and light mode variants for better accessibility

### Testing Notes

Currently, the codebase does not have comprehensive test coverage. When adding tests:
- Use `flutter_test` for unit and widget tests
- Mock repository interfaces for controller testing
- Focus on testing business logic in controllers and repository implementations
- when done do task, always commit the code locally with proper feat, fix, refactor, or styling conventional commits