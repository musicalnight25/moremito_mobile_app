# More Mito Mobile App - Project Analysis

**Project Name:** more_mitro_app  
**Version:** 1.0.0+10  
**Dart SDK:** ^3.5.4  
**Type:** Flutter Mobile Application  
**Date:** April 2, 2026

---

## 📋 Project Overview

More Mito is a comprehensive Flutter mobile application designed for multi-level marketing (MLM) and e-commerce operations. The app provides features for user authentication, order management, compensation tracking, marketing tools, and customer support.

**Target Platforms:**
- ✅ Android (minSdk: 21)
- ✅ iOS
- ✅ Web
- ✅ Linux
- ✅ macOS
- ✅ Windows

---

## 🔧 Technology Stack

### Core Framework
- **Flutter** (Latest stable)
- **Dart** 3.5.4+

### State Management
- **GetX** - Reactive state management and routing

### API & Networking
- **Dio 4.0.6** - HTTP client with interceptors
- **Firebase Core 3.12.0** - Backend services

### Firebase Services
- **Firebase Messaging** - Push notifications & FCM
- **Firebase Remote Config** - Dynamic configuration
- **Firebase Analytics** (implicit via Core)

### Local Storage
- **Hive** - Local NoSQL database
- **Shared Preferences** - Key-value storage
- **Path Provider** - Platform-aware file paths

### UI & Design
- **Flutter ScreenUtil 5.9.3** - Responsive UI scaling
- **Flutter SVG 2.2.4** - SVG asset rendering
- **Lottie 3.1.2** - Animation support
- **Cached Network Image 3.2.0** - Image caching
- **Shimmer 3.0.0** - Loading animations
- **Photo View** - Image zoom & pan
- **Dropdown Button2 2.3.9** - Advanced dropdowns

### Media & Content
- **Image Picker 1.1.2** - Device image selection
- **File Picker 8.0.5** - File browser
- **Video Player 2.10.1** - Video playback
- **Chewie 1.10.0** - Video player wrapper
- **Audio Players 6.1.2** - Audio playback
- **Just Audio 0.10.5** - Audio streaming
- **Flutter InAppWebView 6.0.0** - Web content viewing
- **Flutter Widget from HTML Core** - HTML rendering

### Features & Utilities
- **Permission Handler 11.3.1** - Runtime permissions
- **Connectivity Plus 6.0.5** - Network connectivity
- **Device Info Plus 12.2.0** - Device information
- **Flutter Contacts** - Contact list access
- **Share Plus 10.1.4** - Native sharing
- **URL Launcher** - URL handling
- **Flutter Local Notifications 17.2.2** - Local notifications
- **Flutter App Badger 1.5.0** - App badge count
- **JWT Decoder 2.0.1** - JWT token parsing
- **Intl 0.19.0** - Internationalization
- **ReadMore 3.0.0** - Expandable text
- **Flutter Staggered Grid View 0.7.0** - Advanced grid layouts
- **Phosphor Flutter 2.1.0** - Icon library

### Development Tools
- **Flutter Launcher Icons 0.14.1** - Icon generation
- **Hive Generator 2.0.0** - Code generation
- **Build Runner 2.3.3** - Code generation
- **Flutter Native Splash 2.4.0** - Splash screen configuration

---

## 📁 Project Structure

### Directory Tree

```
lib/
├── main.dart                           # Entry point with Firebase & FCM setup
├── app.dart                            # Root app widget & routing
├── firebase_options.dart               # Firebase configuration
├── share_bottom_sheet.dart             # Shared bottom sheet widget
│
├── controller/                         # Business Logic (GetX Controllers)
│   ├── announcement_details_controller.dart
│   ├── call_details_controller.dart
│   ├── cash_sent_history_controller.dart
│   ├── categories_controller.dart
│   ├── change_password_controller.dart
│   ├── commission_payout_history_controller.dart
│   ├── commission_spent_controller.dart
│   ├── contact_controller.dart
│   ├── deep_link_controller.dart
│   ├── downline_order_detail_controller.dart
│   ├── downline_orders_controller.dart
│   ├── flyers_controller.dart
│   ├── home_controller.dart
│   ├── login_controller.dart
│   ├── my_addresses_controller.dart
│   ├── my_compensation_controller.dart
│   ├── my_daily_compensation_controller.dart
│   ├── my_lead_controller.dart
│   ├── my_profile_controller.dart
│   ├── my_referral_order_detail_controller.dart
│   ├── my_referral_orders_controller.dart
│   ├── notification_controller.dart
│   ├── notification_settings_controller.dart
│   ├── order_controller.dart
│   ├── rank_info_controller.dart
│   ├── shop_moremito_controller.dart
│   ├── survey_controller.dart
│   ├── ticket_controller.dart
│   ├── tmris_controller.dart
│   ├── tmris_lead_controller.dart
│   ├── user_role_controller.dart
│   └── welcome_tag_controller.dart     # 32 controllers total
│
├── model/                              # Data Models
│   ├── announcement_detail_model.dart
│   ├── call_announcement_details_model.dart
│   ├── cash_sent_to_others_model.dart
│   ├── compensation_spent_on_orders_model.dart
│   ├── dashboard_model.dart
│   ├── downline_order_detail_model.dart
│   ├── downline_orders_model.dart
│   ├── flyer_*.dart                    # Flyer-related models (6 files)
│   ├── lead_model.dart
│   ├── login_model.dart
│   ├── my_*_model.dart                 # My account/profile models
│   ├── notification_*.dart             # Notification models
│   ├── order_*.dart                    # Order-related models
│   ├── rank_history_model.dart
│   ├── search_users_for_share_model.dart
│   ├── survey_questions_model.dart
│   ├── ticket_*.dart                   # Support ticket models
│   ├── tmris_*.dart                    # TMRIS-related models
│   ├── user_role_model.dart
│   └── welcome_tag_model.dart          # 50+ model files total
│
├── pages/                              # UI Screens (Feature-based)
│   ├── main_dashboard_screen.dart      # Main navigation hub
│   ├── auth/                           # Authentication screens
│   │   ├── login_screen.dart
│   │   └── start_survey_screen.dart
│   ├── account/                        # Account management
│   │   └── ... (subscreens)
│   ├── category/                       # Product categories
│   │   └── ... (subscreens)
│   ├── compensation/                   # Compensation/earnings
│   │   ├── my_compensation_history_screen.dart
│   │   ├── daily_order_details_screen.dart
│   │   ├── month_details_screen.dart
│   │   └── ... (more screens)
│   ├── home/                           # Home & dashboard
│   │   ├── home_screen.dart
│   │   ├── call_detail_screen.dart
│   │   └── ... (subscreens)
│   ├── marketing/                      # Marketing & flyers
│   │   ├── tmris_leads_screen.dart
│   │   ├── shared_flyers_screen.dart
│   │   └── ... (more screens)
│   ├── notification/                   # Notifications
│   │   ├── notification_settings_screen.dart
│   │   └── ... (more screens)
│   ├── order/                          # Orders management
│   │   ├── my_orders_screen.dart
│   │   └── ... (more screens)
│   ├── profile/                        # User profile
│   │   ├── my_profile_screen.dart
│   │   └── ... (subscreens)
│   ├── setting/                        # App settings
│   │   ├── menu_screen.dart
│   │   ├── upcoming_feature_screen.dart
│   │   ├── widget/
│   │   │   └── menu_section_widget.dart
│   │   └── ... (more screens)
│   └── support/                        # Customer support/tickets
│       └── ... (subscreens)
│
├── service/                            # Business Logic & APIs
│   ├── fcm_service.dart                # Firebase Cloud Messaging
│   ├── network_dio.dart                # HTTP client configuration
│   ├── network_repository.dart         # API repository
│   ├── error_logger.dart               # Error logging service
│   ├── pop_up_service.dart             # Dialog/popup service
│   ├── message_launcher.dart           # SMS/messaging
│   └── webview_helper.dart             # WebView utilities
│
└── utils/                              # Utilities & Constants
    ├── app_constants.dart              # Global constants
    ├── app_asset.dart                  # Asset paths
    ├── app_text_style.dart             # Text styling
    ├── app_translations.dart           # i18n translations
    ├── colors.dart                     # Color palette
    ├── validators.dart                 # Form validators
    ├── preferences_util.dart           # SharedPreferences wrapper
    ├── common_method.dart              # Utility functions
    ├── svg_handler.dart                # SVG rendering utilities
    ├── Widgets (Reusable Components):
    │   ├── common_app_bar.dart
    │   ├── common_bottom_sheet.dart
    │   ├── common_web_view.dart
    │   ├── custom_dropdown_widget.dart
    │   ├── document_viewer_widget.dart
    │   ├── full_screen_image_viewer.dart
    │   ├── input_text_field_widget.dart
    │   ├── network_image_widget.dart
    │   ├── audio_player_widget.dart
    │   ├── video_player_widget.dart
    │   ├── process_indicator.dart
    │   ├── shadow_container_widget.dart
    │   ├── primary_text_button.dart
    │   ├── text_primary_button.dart
    │   ├── base_background_widget.dart
    │   ├── button_styles and decorations
    │   ├── FcmTokenScreen.dart
    │   ├── internet_error.dart
    │   ├── no_data_found.dart
    │   └── static_decoration.dart

assets/
├── images/                             # App graphics & icons
│   ├── ios_logo.jpg
│   ├── logo.png
│   └── ... (more icon/image files)
├── json/                               # JSON data files
│   ├── loader.json                     # Lottie animation
│   ├── nodata.json                     # No data animation
│   └── update.json                     # Update animation
└── google_fonts/                       # Custom font files
    ├── Manrope-Bold.ttf
    ├── Manrope-Medium.ttf
    ├── Manrope-Regular.ttf
    └── Manrope-SemiBold.ttf
```

---

## 🏗️ Architecture Overview

### Architecture Pattern: **MVC + GetX**

The app uses a hybrid approach:
- **Model** → Data models in `lib/model/`
- **View** → UI screens in `lib/pages/`
- **Controller** → Business logic in `lib/controller/` (GetX Controllers)

### Key Architectural Components

#### 1. **Initialization Flow** (main.dart)
```
main()
  ├── WidgetsFlutterBinding.ensureInitialized()
  ├── HttpOverrides setup
  ├── Firebase.initializeApp()
  ├── FCM registration
  ├── Hive initialization
  ├── SharedPreferences init
  └── SystemChrome configurations
```

#### 2. **Routing & Navigation** (app.dart)
- Global `navigatorKey` for Route Observer
- GetX routing configuration
- Push notification stream handling
- Deep link management

#### 3. **State Management** (GetX)
- **32 Controllers** managing individual features
- Reactive variables (`Rx<T>`, `RxList<T>`, `RxMap<T>`)
- GetX dependency injection

#### 4. **API Layer**
- **NetworkDio**: Base HTTP client with interceptors
- **NetworkRepository**: API endpoint definitions
- **Error Handling**: Centralized error logging

#### 5. **Firebase Integration**
- **FCM**: Push notifications + background message handling
- **Remote Config**: Dynamic app configuration
- **Analytics**: User behavior tracking (implicit)

#### 6. **Local Data Persistence**
- **Hive**: Client-side NoSQL database (`contactsBox`)
- **SharedPreferences**: User settings & preferences

---

## 🎯 Key Features

### Authentication
- User login with JWT tokens (`jwt_decoder`)
- Session management via preferences
- Deep link authentication

### Commerce
- **Product Orders**: Browse, order, track orders
- **Order History**: View past orders & compensation
- **Categories**: Product categorization

### Marketing & MLM
- **Flyers & Campaigns**: Create, share, track flyer performance
- **TMRIS Leads**: Lead management system
- **Downline Orders**: Track downline performance
- **Referral Orders**: Monitor referral earnings

### Compensation
- **Daily Compensation**: Track daily earnings
- **Compensation History**: View historical payouts
- **Commission Payouts**: Commission tracking
- **Rank Information**: User rank & tier system

### Communication
- **Notifications**: Push & local notifications
- **Announcements**: System-wide announcements
- **Tickets/Support**: Customer support system
- **Call Details**: Call logs & tracking

### Content Management
- **Surveys**: Completion tracking
- **Documents**: Viewer for PDFs/documents
- **WebView**: In-app web content
- **Rich Media**: Images, videos, audio

### User Management
- **My Profile**: User info & settings
- **Addresses**: Multiple delivery addresses
- **Contacts**: Contact management
- **User Roles**: Role-based access

---

## 🐛 Code Quality Issues Found

### Critical Issues ⛔
1. **Missing dependency**: `flutter_lints` not found (analysis_options.yaml)
2. **Non-final fields in @immutable class** (ShadowContainerWidget)
3. **Always-true null checks** (rank_info_controller.dart:136)
4. **Redundant null modifier on dynamic** (multiple model files)
5. **Duplicate map keys** (notification_detail_model.dart:76)
6. **Unreachable default case** (notification_model.dart:250)

### High Priority Issues ⚠️
7. **Unused imports** (30+ files) - clutters code & increases bundle size
8. **Unused variables & fields** - indicates incomplete refactoring
9. **Unused method declarations** (e.g., `_buildTag` in month_details_screen.dart)
10. **Unnecessary null checks** on non-nullable values

### Medium Priority Issues 📋
11. Code organization - some utility files could be grouped better
12. Inconsistent naming conventions across models
13. Missing error boundaries in some widgets

---

## 📊 Statistics

| Metric | Count | Notes |
|--------|-------|-------|
| **Controllers** | 32 | State management |
| **Models** | 50+ | Data structures |
| **Pages/Screens** | 40+ | UI implementation |
| **Services** | 7 | Business logic |
| **Utility files** | 25+ | Helpers & components |
| **Dependencies** | 40+ | External packages |
| **Lines of Code** | ~50,000+ | Estimated |
| **Compile Errors** | 43 | Need fixing |

---

## ⚙️ Configuration Files

### pubspec.yaml
- **Flutter SDK**: Latest stable
- **Minimum Flutter version**: Required
- **Asset management**: Images, JSON, fonts (Manrope)
- **Platform configuration**:
  - Android: minSdk 21
  - iOS: Standard deployment
  - Web, Linux, macOS, Windows: Supported

### Firebase Configuration
- `firebase_options.dart` - Platform-specific Firebase settings
- `google-services.json` - Android Firebase config
- `GoogleService-Info.plist` - iOS Firebase config

### Native Configuration
- **Android**: Gradle build, Firebase, custom key properties
- **iOS**: CocoaPods, Xcode workspace setup
- **Web**: Flutter web setup with manifest
- **Desktop**: CMake build configuration

---

## 🔒 Security Considerations

1. **JWT Token Handling**: Uses `jwt_decoder` for token parsing
2. **Permission Management**: Runtime permissions via `permission_handler`
3. **Network Security**: HTTPS interceptor in NetworkDio
4. **Local Storage**: Sensitive data in SharedPreferences/Hive (encryption recommended)
5. **Firebase Rules**: Ensure Firestore/Auth rules are properly configured

---

## 📈 Performance Optimizations Applied

✅ **Image Caching**: `cached_network_image`  
✅ **Responsive Design**: `flutter_screenutil`  
✅ **Loading States**: `shimmer` animations  
✅ **Local Database**: Hive for offline support  
✅ **Lazy Loading**: Pagination in lists (implied)  
✅ **Asset Optimization**: SVG for scalable graphics  

---

## 🚀 Recommendations

### Immediate Actions (Priority 1)
1. [ ] Fix `flutter_lints` dependency issue
2. [ ] Remove all 30+ unused imports
3. [ ] Fix non-final fields in @immutable classes
4. [ ] Remove unused variables and methods
5. [ ] Fix null safety issues in models
6. [ ] Resolve duplicate map keys

### Short-term Improvements (Priority 2)
7. [ ] Add null safety analysis to CI/CD
8. [ ] Implement error boundary widgets
9. [ ] Create utility class grouping helper methods
10. [ ] Add comprehensive error logging
11. [ ] Document API endpoints in service layer
12. [ ] Add unit tests for controllers

### Medium-term Enhancements (Priority 3)
13. [ ] Refactor to MVVM pattern for better testability
14. [ ] Implement dependency injection container
15. [ ] Add analytics tracking
16. [ ] Create design system documentation
17. [ ] Optimize bundle size
18. [ ] Add form validation framework
19. [ ] Implement offline-first data sync

### Code Quality (Priority 4)
20. [ ] Run `dart format` on entire project
21. [ ] Configure pre-commit hooks
22. [ ] Add comprehensive code comments
23. [ ] Create architecture documentation
24. [ ] Add feature flags for A/B testing
25. [ ] Implement error reporting (Sentry/Firebase)

---

## 🔍 File Quality Checklist

### Models
- [ ] Add validation logic
- [ ] Implement `copyWith()` methods
- [ ] Add `equality` operators for testing
- [ ] Document nullable vs required fields

### Controllers
- [ ] Add proper error handling
- [ ] Implement loading states
- [ ] Add input validation
- [ ] Document API dependencies

### Pages/Screens
- [ ] Consistent error handling UI
- [ ] Loading indicators for async operations
- [ ] Empty state handling
- [ ] Accessibility (a11y) support

### Services
- [ ] Timeout configuration
- [ ] Retry logic for network calls
- [ ] Request/response logging
- [ ] Cache invalidation strategy

---

## 📝 Next Steps

1. **Review Errors**: Address the 43 compilation errors systematically
2. **Code Cleanup**: Remove unused imports and variables
3. **Testing**: Implement unit and widget tests
4. **Documentation**: Add code comments and API documentation
5. **Release Preparation**: Build and test APK/IPA for release
6. **Deployment**: Configure CI/CD pipeline for automatic builds

---

## 📞 Support & Contacts

- **Firebase Dashboard**: [Console](https://console.firebase.google.com/)
- **Flutter Documentation**: [flutter.dev](https://flutter.dev/)
- **GetX Documentation**: [GetX Docs](https://pub.dev/packages/get)

---

**Analysis Generated**: April 2, 2026  
**Status**: Ready for development with issues to address
