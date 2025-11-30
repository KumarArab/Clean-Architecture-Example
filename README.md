# Clean Architecture Flutter Example

A comprehensive Flutter project demonstrating **Clean Architecture** principles with Firebase authentication, BLoC state management, dependency injection, and extensive testing practices.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Testing](#testing)
- [Getting Started](#getting-started)
- [Documentation](#documentation)

## 🎯 Overview

This project serves as a learning resource and reference implementation for:
- **Clean Architecture** in Flutter
- **BLoC/Cubit** state management patterns
- **Dependency Injection** using GetIt
- **Firebase Authentication** integration
- **Comprehensive Testing** (Unit & Widget tests)
- **Best Practices** for Flutter development

## 🏗 Architecture

The project follows **Clean Architecture** principles, organizing code into three main layers:

### 1. **Presentation Layer** (`presentation/`)
- UI components (Screens, Widgets)
- State management (BLoC, Cubit)
- User interactions and events

### 2. **Domain Layer** (`domain/`)
- Business logic and entities
- Repository interfaces
- Use cases (business rules)

### 3. **Data Layer** (`data/`)
- Data sources (API, Firebase, Local DB)
- Repository implementations
- Data models (DTOs)

### Core Layer (`core/`)
- Shared utilities, constants, and common components
- Dependency injection setup
- Theme configuration
- Navigation
- Error handling
- Logging

## ✨ Features

### Authentication Module
- **Login** functionality with Firebase Auth
- **Sign Up** with email/password
- **Sign Out** capability
- **User session management** (check if user is logged in)
- Complete authentication flow with BLoC pattern

### Home Module
- Home screen implementation
- User session-based navigation

### Testing Practice Modules
- **Unit Testing Practice**: Examples covering BLoC, Cubit, ChangeNotifier, async operations, streams, mocking, and repository/use case testing
- **Widget Testing Practice**: Examples for testing authentication screens, greeting widgets, pagination, and list screens

## 🛠 Tech Stack

### Core Dependencies
- **flutter_bloc** (^9.1.1) - State management
- **get_it** (^9.1.1) - Dependency injection
- **firebase_auth** (^6.1.2) - Firebase authentication
- **firebase_core** (^4.2.1) - Firebase core functionality
- **fpdart** (^1.2.0) - Functional programming utilities (Either type)
- **google_fonts** (^6.3.0) - Custom typography
- **equatable** (^2.0.7) - Value equality for objects
- **json_annotation** (^4.9.0) - JSON serialization annotations
- **freezed_annotation** (^2.4.4) - Immutable classes and unions

### Development Dependencies
- **build_runner** (^2.4.15) - Code generation
- **json_serializable** (^6.9.5) - JSON serialization
- **freezed** (^3.0.0-0.0.dev) - Code generation for immutable classes
- **bloc_test** (^10.0.0) - Testing utilities for BLoC
- **mocktail** (^1.0.4) - Mocking library for testing
- **flutter_lints** (^5.0.0) - Linting rules

## 📁 Project Structure

```
lib/
├── auth/                          # Authentication feature module
│   ├── data/
│   │   ├── datasources/          # Firebase data source implementation
│   │   ├── models/               # User model (with freezed & json_serializable)
│   │   └── repos/                # Auth repository implementation
│   ├── domain/
│   │   ├── entities/             # Domain entities
│   │   ├── repos/                # Repository interfaces
│   │   └── usecases/             # Business logic use cases
│   │       ├── login_usecase.dart
│   │       ├── signup_usecase.dart
│   │       ├── sign_out_usecase.dart
│   │       └── is_user_logged_in_usecase.dart
│   └── presentation/
│       ├── bloc/                 # Auth BLoC (events, states, bloc)
│       ├── screens/              # Login & Signup screens
│       └── widgets/              # Reusable auth widgets
│
├── home/                          # Home feature module
│   └── presentation/
│       ├── screens/              # Home screen
│       └── widgets/              # Home widgets
│
├── core/                          # Core/shared functionality
│   ├── commons/                  # Common utilities
│   │   └── cubits/               # App-wide cubits (AppUserCubit)
│   ├── constants/                 # App constants
│   ├── di/                        # Dependency injection setup
│   ├── entities/                  # Core entities (Failure, User)
│   ├── exceptions/                # Custom exceptions
│   ├── logger/                    # Logging utilities
│   ├── navigation/                # Navigation observer
│   ├── theme/                     # App theme configuration
│   └── usecase/                   # Base use case interface
│
├── unit_testing_practice/         # Unit testing examples
│   ├── bloc/                     # BLoC testing examples
│   ├── cubit/                    # Cubit testing examples
│   ├── changeNotifier/           # ChangeNotifier testing examples
│   ├── simple_tests.dart         # Basic unit tests
│   ├── simple_async_tests.dart   # Async testing examples
│   ├── stream_tests.dart         # Stream testing examples
│   ├── mock_tests.dart           # Mocking examples
│   └── repo_usecase_tests.dart   # Repository & use case testing
│
├── widget_testing_practice/       # Widget testing examples
│   ├── auth/                     # Auth widget tests
│   ├── greeting/                 # Greeting widget tests
│   └── pagination/               # Pagination widget tests
│
└── main.dart                      # App entry point
```

## 🧪 Testing

The project includes comprehensive testing examples and practices:

### Unit Tests (`test/testing_practice/`)
- **BLoC Tests**: Testing BLoC state management
- **Cubit Tests**: Testing Cubit state management
- **ChangeNotifier Tests**: Testing ChangeNotifier pattern
- **Simple Tests**: Basic unit testing fundamentals
- **Async Tests**: Testing asynchronous operations
- **Stream Tests**: Testing stream-based operations
- **Mock Tests**: Mocking dependencies with mocktail
- **Repository & Use Case Tests**: Testing clean architecture layers

### Widget Tests (`test/widget_testing_practice/`)
- **Auth Widget Tests**: Testing login screens and authentication flows
- **Greeting Widget Tests**: Testing widgets with FutureBuilder
- **Pagination Widget Tests**: Testing infinite scroll and list pagination

### Testing Documentation
- **Unit Testing Roadmap** (`docs/unit_test_roadmap.md`): Comprehensive guide covering:
  - Foundations of unit testing
  - Async testing patterns
  - Stream testing
  - Mocking with mocktail
  - Repository & use case testing
  - BLoC/Cubit/ChangeNotifier testing
  - Time manipulation (fake_async)
  - Debounce & throttle testing
  - Error handling tests
  - Architecture for testability

- **Widget Testing Roadmap** (`docs/widget_test_roadmap.md`): Complete guide covering:
  - Widget test basics
  - Pumping & frames
  - Finders & matchers
  - User interactions
  - Async widgets (FutureBuilder/StreamBuilder)
  - State management integration
  - Navigation testing
  - Lists & pagination
  - Animations & time control
  - Golden tests
  - And much more...

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.6.1)
- Dart SDK
- Firebase project setup
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd cleanarchexample
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**
   - Add your `google-services.json` to `android/app/`
   - Add your `GoogleService-Info.plist` to `ios/Runner/`
   - Configure Firebase for your project

4. **Generate code** (for freezed and json_serializable)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/testing_practice/simple_tests_test.dart

# Run with coverage
flutter test --coverage
```

## 📚 Documentation

### Architecture Documentation
- The project follows Clean Architecture principles with clear separation of concerns
- Each feature module is self-contained with its own data, domain, and presentation layers

### Testing Documentation
- See `docs/unit_test_roadmap.md` for comprehensive unit testing guide
- See `docs/widget_test_roadmap.md` for comprehensive widget testing guide

### Code Examples
- Check `lib/unit_testing_practice/` for unit testing examples
- Check `lib/widget_testing_practice/` for widget testing examples
- Check `test/` directory for corresponding test implementations

## 🎓 Learning Resources

This project is designed as a learning resource for:
- Understanding Clean Architecture in Flutter
- Implementing BLoC pattern correctly
- Setting up dependency injection
- Writing comprehensive tests (unit & widget)
- Firebase integration best practices
- Production-ready Flutter app structure

## 📝 Notes

- The project uses **GetIt** for dependency injection
- **Freezed** is used for immutable data classes
- **fpdart** provides functional programming utilities (Either type for error handling)
- All use cases return `Either<Failure, SuccessType>` for type-safe error handling
- The project includes both production code and practice examples for testing

## 🤝 Contributing

This is a learning project. Feel free to explore, learn, and adapt the patterns to your own projects.

## 📄 License

This project is for educational purposes.

---

**Happy Learning! 🚀**
