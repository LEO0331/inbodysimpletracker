# InBody Simple Tracker

A Flutter application for tracking InBody fitness reports, cloud storage, and analytics dashboard. Users can scan, upload or input InBody reports, extract metrics automatically, and track their fitness progress over time.

## 🎯 Features

### Authentication
- ✅ User registration and login with Firebase Authentication
- ✅ Email/password authentication
- ✅ Session management with provider state management
- ✅ User role management (admin/user)
- ✅ Logout with confirmation dialog

### Quick Scan & Data Extraction
- ✅ **OCR Text Recognition** - Automatically extract metrics from InBody report photos using Google ML Kit
- ✅ **Manual Input** - Option to manually enter metrics (useful for web platform)
- ✅ **Auto-Save** - Reports automatically saved to Firestore after extraction
- ✅ **Multiple Metrics** - Captures weight, body fat %, muscle mass, and visceral fat

### Dashboard & Analytics
- ✅ **Report History** - View all saved reports in a chronological list
- ✅ **Expandable Cards** - Click to see detailed metrics for each report
- ✅ **Summary Cards** - Quick stats showing total reports and latest report date
- ✅ **Delete Functionality** - Remove individual reports
- ✅ **Real-time Updates** - Firestore Stream for live data

### User Interface
- ✅ **Responsive Design** - Works on mobile, tablet, and web
- ✅ **Material Design 3** - Modern, clean UI with Flutter Material components
- ✅ **Dark/Light Mode Support** - Adapts to system theme
- ✅ **Navigation** - Smooth routing between pages with proper state management

## 📱 Screenshots & User Flow

```
HomePage (Landing Page)
├── Not Authenticated
│   ├── Quick Scan Button → Login required
│   ├── Login Button → LoginPage
│   └── Sign Up Button → SignupPage
└── Authenticated
    └── Shows UploadPage

UploadPage (Main App)
├── Select Image from Gallery
├── Auto-extract with OCR (mobile/native)
├── Manual Input (web/fallback)
├── Save to Firestore
├── Dashboard Button (top right)
└── User Menu (top right)
    ├── Show profile email
    └── Logout Button

DashboardPage
├── Summary Cards
│   ├── Total Reports Count
│   └── Latest Report Date
└── Reports List
    ├── Expandable Report Cards
    │   ├── Date & Weight
    │   └── Detailed Metrics (expand)
    │       ├── Weight (kg)
    │       ├── Body Fat %
    │       ├── Muscle Mass (kg)
    │       ├── Visceral Fat
    │       └── Delete Button
    └── Empty State (no reports)
```

## 🏗️ Project Architecture

### Folder Structure
```
lib/
├── main.dart                           # App entry point
├── core/
│   └── app_router.dart                # Route management
├── data/
│   ├── models/
│   │   └── inbody_report.dart         # InbodyReport model
│   └── services/
│       ├── auth_service.dart          # Firebase Auth service
│       └── firestore_service.dart     # Firestore operations
├── logic/
│   └── providers/
│       ├── auth_provider.dart         # Authentication state management
│       └── report_provider.dart       # Reports state management
└── presentation/
    ├── auth/
    │   ├── login_page.dart            # Login screen
    │   └── signup_page.dart           # Sign up screen
    ├── dashboard/
    │   ├── dashboard_page.dart        # Reports dashboard
    │   └── report_card.dart           # Report card widget
    ├── upload/
    │   └── upload_page.dart           # Image scan & upload
    ├── home/
    │   └── home_page.dart             # Landing page
    └── admin/
        └── admin_page.dart            # Admin panel
```

### Architecture Pattern: MVC + Provider

- **Model**: `inbody_report.dart` - Data models for InBody reports
- **View**: Flutter UI components in `presentation/` folder
- **Controller**: `AuthProvider` and `ReportProvider` using Provider package for state management

## 🔧 Technologies & Dependencies

### Core Framework
- **Flutter 3.11+** - UI framework
- **Dart 3.11+** - Programming language

### State Management
- **Provider 6.1.2** - State management and dependency injection

### Backend & Database
- **Firebase Core 2.30.0** - Firebase initialization
- **Firebase Auth 4.19.0** - User authentication
- **Cloud Firestore 4.17.0** - Cloud database

### AI & ML
- **Google ML Kit Text Recognition 0.11.0** - OCR text extraction

### UI & UX
- **Material Design 3** - Built-in Flutter Material components
- **FL Chart 0.69.0** - Charts and graphs

### Utilities
- **Image Picker 1.2.1** - Select images from gallery/camera
- **Intl 0.20.2** - Date/time formatting

See `pubspec.yaml` for complete dependencies list.

## 🚀 Getting Started

### Prerequisites
- Flutter 3.11+ installed
- Dart 3.11+ SDK
- Firebase project set up
- iOS/Android development environment

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/LEO0331/inbodysimpletracker.git
   cd inbodysimpletracker
   ```

2. **Switch to development branch**
   ```bash
   git checkout main
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Configure Firebase**
   - Create a Firebase project at [firebase.google.com](https://firebase.google.com)
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place files in appropriate Android/iOS directories
   - Update `firebase_options.dart` with your Firebase configuration

5. **Run the app**
   ```bash
   flutter run
   ```

## 📋 Core Components

### Authentication (`auth_provider.dart`)
- User login/signup/logout
- Error message handling
- Loading states
- User authentication status tracking
- Admin role checking

### Upload & OCR (`upload_page.dart`)
- Pick images from gallery
- Process with Google ML Kit OCR
- Parse metrics with regex patterns
- Save to Firestore
- Manual input fallback

```dart
// Supported metrics extraction
- Weight (kg)
- Body Fat Percentage (%)
- Muscle Mass (kg)
- Visceral Fat
```

### Dashboard (`dashboard_page.dart`)
- Real-time Firestore streaming
- Report listing and filtering
- Expandable report details
- Delete functionality
- Summary statistics

### Report Card (`report_card.dart`)
- Reusable report display component
- Expandable UI
- Delete confirmation
- Formatted date display

### Collections Structure
```
users/
├── {uid}/
│   ├── email: string
│   ├── role: string (user/admin)
│   ├── createdAt: timestamp
│   └── reports/
│       └── {reportId}/
│           ├── reportDate: timestamp
│           ├── weight: double
│           ├── bodyFatPercent: double
│           ├── muscleMass: double
│           └── visceralFat: double
```

## 🧪 Testing

### Manual Testing Checklist
- [ ] User can register with valid email/password
- [ ] User can login with correct credentials
- [ ] Login fails with incorrect password
- [ ] OCR correctly extracts metrics from InBody report
- [ ] Metrics save to Firestore
- [ ] Dashboard displays all saved reports
- [ ] Report can be deleted
- [ ] User can logout and return to login page
- [ ] App works on Android, iOS, and Web

## 📝 Error Handling

### Firebase Authentication Errors
- `user-not-found` - No account with this email
- `wrong-password` - Incorrect password
- `email-already-in-use` - Email already registered
- `weak-password` - Password too short
- `too-many-requests` - Too many login attempts

### UI Error Display
- Error messages shown in red alert boxes
- Form validation before submission
- Loading spinners during async operations
- Empty states for no data

## 🎨 UI/UX Features

### Color Scheme
- **Primary**: Blue
- **Error**: Red
- **Success**: Green
- **Neutral**: Grey shades

### Typography
- **Headlines**: Bold, larger font sizes
- **Body**: Regular weight for readability
- **Captions**: Smaller, muted colors

### Accessibility
- Touch targets minimum 48x48 dp
- Sufficient color contrast
- Descriptive button labels
- Tooltip hints for icons

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android | ✅ Supported | Full OCR support |
| iOS | ✅ Supported | Full OCR support |
| Web | ✅ Supported | Manual input only (OCR fallback) |

## 🔄 Data Flow

```
User Input (Photo/Manual)
    ↓
OCR Processing (ML Kit)
    ↓
Regex Metric Parsing
    ↓
Validation
    ↓
Save to Firestore
    ↓
Update Provider State
    ↓
UI Update (Real-time)
```

# Unit Tests for InBody Simple Tracker

## Test Coverage

### 1. `auth_provider_test.dart`
Tests for authentication state management provider.

**Coverage:**
- Initial state validation
- Login functionality
  - Valid credentials
  - Empty email validation
  - Empty password validation
  - Error handling
- Signup functionality
  - Valid credentials
  - Email validation
  - Password length validation
  - Duplicate email detection
- Logout functionality
- Firebase error message mapping
- Error clearing

### 2. `inbody_report_test.dart`
Tests for InbodyReport data model.

**Coverage:**
- Constructor initialization
- Equality comparison
- Model serialization (toMap)
- Model deserialization (fromMap)
- Edge cases (zero metrics, negative values, empty ID)
- copyWith functionality
- toString representation

### 3. `report_provider_test.dart`
Tests for report state management provider.

**Coverage:**
- Initial state
- Add report
- Remove report
- Clear reports
- Get report by ID
- Statistical calculations
  - Latest report
  - Average weight
  - Total reports
- Listener notifications

### 4. `app_router_test.dart`
Tests for route generation and navigation.

**Coverage:**
- Home route generation
- Login route generation
- Signup route generation
- Upload route generation
- Dashboard route generation
- Unknown route handling

### 5. `inbody_metrics_parser_test.dart`
Tests for OCR text parsing and metric extraction.

**Coverage:**
- Full metric parsing
- Individual metric parsing
- Decimal value handling
- Integer value handling
- Missing metric handling
- Case sensitivity
- Empty string handling

## Running Tests

### Run all tests
```bash
flutter test
```

### Run specific test file
```bash
flutter test test/auth_provider_test.dart
```

### Run tests with verbose output
```bash
flutter test --verbose
```

### Run tests with coverage
```bash
flutter test --coverage
```

### Run tests in watch mode (auto-rerun on changes)
```bash
flutter test --watch
```

## Test Statistics

| Module | Tests | Coverage |
|--------|-------|----------|
| **Total** | **61** | **~93%** |

## Installation

### 1. Add test dependencies to `pubspec.yaml`
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^6.1.0
  build_runner: ^2.4.0
```

### 2. Run pub get
```bash
flutter pub get
```

### 3. Generate mocks (if using Mockito)
```bash
flutter pub run build_runner build
```

## Resources
- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Mockito Package](https://pub.dev/packages/mockito)
- [Flutter Unit Testing Best Practices](https://codewithandrea.com/articles/flutter-testing/)

**Last Updated**: March 2026  
**Test Framework Version**: Flutter Test Framework  
**Target Coverage**: >85%

## 📺 Demo & Preview

### 🌐 Live Access
- **Web Demo**: [InBody Simple Tracker](https://leo0331.github.io/inbodysimpletracker/) 

### 📸 UI Gallery
### 1. Login/Signup
![Demo7](assets/images/demo7.png)
![Demo8](assets/images/demo8.png)
![Demo9](assets/images/demo9.png)

### 2. User Dashboard
![Demo1](assets/images/demo1.png)
![Demo2](assets/images/demo2.png)
![Demo3](assets/images/demo3.png)

### 3. Admin Dashboard
![Demo4](assets/images/demo4.png)
![Demo5](assets/images/demo5.png)
![Demo6](assets/images/demo6.png)
