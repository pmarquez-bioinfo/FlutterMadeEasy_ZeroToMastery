# Flutter Development Log

This document tracks the development progress and changes made to the Flutter Made Easy Zero to Mastery course projects.

## 🚀 Roadmap & Next Work

### Current Sprint

- [x] **Domain Layer Implementation**: Create proper domain entities for advice data
- [x] **Error Handling**: Add proper failure handling for use cases
- [x] **Repository Pattern**: Implement data repository layer
- [x] **Data Source Integration**: Connect repository to actual data sources
- [ ] **iOS Home Widget**: Develop iOS home screen widget to display advice
- [ ] **Entity Architecture**: Structure advice models with proper data validation
- [ ] **Host Express Server**: Set up Express server for backend API and Swagger documentation
- [ ] **Unit Tests**: Add unit tests for domain layer and use cases
- [ ] **Local Data Source**: Implement caching mechanism with local storage

### Backlog

- [ ] Add real data source integration
- [ ] Implement item persistence for column display
- [ ] Add item creation/deletion functionality
- [ ] Enhance error handling and user feedback
- [ ] Consider adding animations and transitions
- [ ] Implement advice caching mechanism
- [ ] Add unit tests for BLoC components

---

## August 24, 2025 - Custom Exceptions and Enhanced Error Handling

**Commit:** `340adcf` - "Add custom exceptions and improve error handling"  
**Branch:** `dev`  
**Author:** Pablo Marquez  
**Date:** August 24, 2025

### Summary

Introduced custom exception classes for granular error handling and improved the error propagation throughout the data layer. This enhancement provides more specific error handling for different failure scenarios and better separation between exceptions and domain failures.

### Key Changes

#### 🆕 New Features

- **Custom Exception Classes**: Created dedicated exception types for different error scenarios
  - `ServerException`: For server and API-related errors
  - `CacheException`: For local storage and caching errors
  - Proper message handling with required parameters
  - Clear separation from domain layer failures

- **Enhanced Data Source Error Handling**: Updated remote data source to throw specific exceptions
  - `ServerException` thrown when API calls fail (non-200 status codes)
  - Improved error messaging with context-specific information
  - Better debugging capabilities with structured exception handling

- **Repository Exception Catching**: Implemented proper exception-to-failure mapping
  - Catches `ServerException` and maps to `ServerFailure`
  - Catches `CacheException` and maps to `CacheFailure`
  - Maintains fallback for unexpected exceptions
  - Preserves error messages through the transformation

#### 🏗️ Architecture

- **Exception Layer**: Clean separation between data layer exceptions and domain failures

```dart
// Custom exceptions for data layer
class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}
```

- **Data Source Exception Handling**: Updated to throw structured exceptions

```dart
class AdviceRemoteDatasourceImplementation implements AdviceRemoteDataSource {
  @override
  Future<AdviceModel> getRandomAdviceFromAPI() async {
    // ... HTTP request logic
    
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return AdviceModel.fromJson(jsonResponse);
    } else {
      throw ServerException(message: 'Failed to load advice');
    }
  }
}
```

- **Repository Exception-to-Failure Mapping**: Proper error transformation

```dart
class AdviceRepositoryImplementation implements AdviceRepository {
  @override
  Future<Either<Failure, AdviceEntity>> getAdviceFromDataSource() async {
    try {
      final adviceEntity = await adviceRemoteDatasource.getRandomAdviceFromAPI();
      return Right(adviceEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

#### 🔧 Technical Details

- **Exception Design Pattern**: Proper exception inheritance and structure
  - Implements `Exception` interface for type safety
  - Required message parameter for debugging context
  - Lightweight design focused on error information transport

- **Error Propagation Chain**: Clear error flow through architecture layers
  - Data Source → Custom Exceptions → Repository → Domain Failures → Use Cases → UI
  - Type-safe exception handling with specific catch blocks
  - Message preservation throughout the error chain

- **Clean Architecture Compliance**: Maintains dependency inversion
  - Exceptions belong to data layer, not domain
  - Repository acts as translator between data exceptions and domain failures
  - Domain layer remains independent of data layer implementation details

### Files Added/Modified

#### New Files

- `0_data/exceptions/exceptions.dart` - Custom exception classes for data layer

#### Modified Files

- `0_data/datasources/advice_remote_datasource.dart` - Updated to throw ServerException
- `0_data/repositories/advice_repository_implementation.dart` - Added exception catching and mapping

### Learning Outcomes

- **Exception Design**: Understanding custom exception implementation in Dart
- **Error Handling Patterns**: Separation between exceptions and domain failures
- **Clean Architecture**: Proper error boundary management across layers
- **Type Safety**: Specific exception catching for better error handling
- **Error Propagation**: Maintaining error context through architectural layers

### Next Steps

- Add network connectivity checking before API calls
- Implement cache exceptions for local storage scenarios
- Add retry mechanisms for recoverable server errors
- Create exception unit tests for comprehensive coverage
- Consider adding error analytics and logging

---

## August 24, 2025 - iOS Configuration and HTTP Client Improvements

**Commit:** `1f5d78c` - "Update iOS config and improve HTTP client handling"  
**Branch:** `dev`  
**Author:** Pablo Marquez  
**Date:** August 24, 2025

### Summary

Updated iOS project configuration with proper bundle identifier, development team settings, and enhanced HTTP client to handle SSL certificate issues. This ensures better compatibility for iOS development and resolves potential network connectivity problems with HTTPS endpoints.

### Key Changes

#### 📱 **iOS Configuration Updates**

- **Xcode Project Settings**: Updated iOS project configuration
  - Set proper bundle identifier for app distribution
  - Configured development team settings for code signing
  - Enhanced project build settings for better compatibility

- **Info.plist Optimization**: Updated iOS app configuration
  - Adjusted frame duration settings for better performance
  - Updated indirect input events handling
  - Improved iOS-specific app behavior settings

#### 🔧 **HTTP Client Enhancement**

- **SSL Certificate Handling**: Implemented custom HTTP client for development
  - Added `IOClient` with custom `HttpClient` configuration
  - Implemented certificate bypass for development environments
  - Better handling of HTTPS endpoints with self-signed certificates

- **Network Resilience**: Improved API connectivity
  - Custom certificate callback to handle SSL issues
  - Maintained proper HTTP headers and request structure
  - Enhanced error handling for network-related problems

#### 🏗️ Architecture

- **Enhanced HTTP Client Implementation**: Custom client for better SSL handling

```dart
class AdviceRemoteDatasourceImplementation implements AdviceRemoteDataSource {
  @override
  Future<AdviceModel> getRandomAdviceFromAPI() async {
    // Custom HTTP client with SSL certificate handling
    final httpClient = HttpClient()
      ..badCertificateCallback = (cert, host, port) => true;
    final client = IOClient(httpClient);

    final response = await client.get(
      Uri.parse('https://api.flutter-community.com/api/v1/advice'),
      headers: {
        'content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return AdviceModel.fromJson(jsonResponse);
    } else {
      throw ServerException(message: 'Failed to load advice');
    }
  }
}
```

#### 🔧 Technical Details

- **IOClient Integration**: Enhanced HTTP handling capabilities
  - `IOClient` wrapper around custom `HttpClient`
  - Certificate callback for development SSL bypass
  - Maintained compatibility with existing HTTP package patterns

- **iOS Development Setup**: Proper project configuration
  - Bundle identifier configuration for app store compliance
  - Development team settings for local development
  - Code signing configuration for device testing

- **Network Security**: Development-friendly SSL handling
  - Certificate bypass for development and testing
  - Maintained proper HTTPS usage for production readiness
  - Clear separation between development and production configurations

### Files Added/Modified

#### Modified Files

- `ios/Runner.xcodeproj/project.pbxproj` - Updated Xcode project settings and build configuration
- `ios/Runner/Info.plist` - Enhanced iOS app configuration and performance settings
- `0_data/datasources/advice_remote_datasource.dart` - Improved HTTP client with SSL handling

### Learning Outcomes

- **iOS Development**: Understanding Xcode project configuration and settings
- **HTTP Client Customization**: Advanced HTTP client configuration in Dart
- **SSL Certificate Management**: Handling certificate issues in development
- **Network Programming**: Custom HTTP client implementation patterns
- **Mobile Platform Integration**: iOS-specific development considerations

### Next Steps

- Implement production-ready SSL certificate validation
- Add network connectivity checking before API calls
- Create environment-specific HTTP client configurations
- Add proper logging for network requests and responses
- Consider implementing request retry mechanisms

---

## July 19, 2025 - Data Layer Implementation with Repository Pattern

**Commit:** `bff40f9` - "added advice model, remote data source from API, and repository implementation."  
**Branch:** `dev`  
**Author:** Pablo Marquez  
**Date:** July 19, 2025

### Summary

Completed the data layer implementation with full Clean Architecture integration, including data models, remote data sources, and repository pattern. Connected the app to a real external API (flutter-community.com) for fetching advice, establishing a complete data flow from API to UI with proper error handling.

### Key Changes

#### 🆕 New Features

- **Data Models**: Created `AdviceModel` with JSON serialization
  - Extends `AdviceEntity` for clean architecture compliance
  - `fromJson()` factory constructor for API response parsing
  - `toJson()` method for data serialization
  - Proper handling of API field mapping (`advice_id` to `id`)

- **Remote Data Source**: Implemented HTTP API integration
  - Abstract interface `AdviceRemoteDataSource` for testability
  - Concrete implementation `AdviceRemoteDatasourceImplementation`
  - Real API integration with flutter-community.com advice endpoint
  - Proper HTTP headers and error handling

- **Repository Implementation**: Complete repository pattern
  - `AdviceRepositoryImplementation` implementing domain interface
  - Dependency injection of remote data source
  - Error handling with Either pattern integration
  - Clean separation between data and domain layers

#### 🏗️ Architecture

- **Clean Architecture Data Layer**: Complete implementation following Uncle Bob's principles

```dart
// Data Model with JSON serialization
class AdviceModel extends AdviceEntity with EquatableMixin {
  const AdviceModel({
    required String id,
    required String advice,
  }) : super(id: id, advice: advice);

  // Factory constructor for API response parsing
  factory AdviceModel.fromJson(Map<String, dynamic> json) {
    return AdviceModel(
      id: json['advice_id'].toString(),
      advice: json['advice'] as String,
    );
  }

  // Method for data serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'advice': advice,
    };
  }

  @override
  List<Object?> get props => [id, advice];
}
```

- **Remote Data Source with HTTP Client**:

```dart
abstract class AdviceRemoteDataSource {
  /// Fetches a random piece of advice from the remote server.
  /// Returns a [AdviceModel] containing the advice.
  /// Throws a [ServerException] if the request fails, and status code is not 200.
  Future<AdviceModel> getRandomAdviceFromAPI();
}

class AdviceRemoteDatasourceImplementation implements AdviceRemoteDataSource {
  final http.Client httpClient = http.Client();

  @override
  Future<AdviceModel> getRandomAdviceFromAPI() async {
    final response = await httpClient.get(
      Uri.parse('https://api.flutter-community.com/api/v1/advice'),
      headers: {
        'content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return AdviceModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load advice');
    }
  }
}
```

- **Repository Implementation with Error Handling**:

```dart
class AdviceRepositoryImplementation implements AdviceRepository {
  final AdviceRemoteDatasourceImplementation adviceRemoteDatasource = 
      AdviceRemoteDatasourceImplementation();

  @override
  Future<Either<Failure, AdviceEntity>> getAdviceFromDataSource() async {
    try {
      // Fetch advice from the remote data source
      final adviceEntity = await adviceRemoteDatasource.getRandomAdviceFromAPI();
      
      // Return the entity wrapped in a Right (success)
      return Right(adviceEntity);
    } catch (e) {
      // If an error occurs, return a Left (failure)
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

- **Simplified Use Cases with Repository Delegation**:

```dart
class AdviceUscases {
  final AdviceRepository adviceRepository = AdviceRepositoryImplementation();

  Future<Either<Failure, AdviceEntity>> getAdvice() async {
    return await adviceRepository.getAdviceFromDataSource();
  }
}
```

#### 📱 App Structure Updates

- **Data Layer Organization**: Complete 3-layer Clean Architecture
  - `0_data/models/` for data models with JSON serialization
  - `0_data/datasources/` for external data source implementations
  - `0_data/repositories/` for repository implementations
  - Clear dependency direction: data → domain ← application

- **Domain Interface**: Updated repository interface
  - `AdviceRepository` abstract class in domain layer
  - Defines contract for data access without implementation details
  - Maintains dependency inversion principle

#### 🔧 Technical Details

- **HTTP Package Integration**: Added HTTP client for API calls
  - `http: ^1.4.0` dependency in pubspec.yaml
  - Proper HTTP headers and status code handling
  - JSON parsing with dart:convert

- **Data Flow Architecture**: Complete end-to-end data flow
  - API → Data Source → Repository → Use Cases → Cubit → UI
  - Proper error propagation through all layers
  - Type safety maintained throughout the chain

- **Dependency Management**: Concrete dependency injection
  - Repository instantiated in use cases
  - Data source instantiated in repository
  - Prepared for dependency injection container

- **Error Handling Integration**: Seamless error propagation
  - HTTP exceptions caught and converted to domain failures
  - Either pattern maintained through all layers
  - User-friendly error messages in UI layer

### Files Added/Modified

#### New Files

- `0_data/models/advice_model.dart` - Data model with JSON serialization
- `0_data/datasources/advice_remote_datasource.dart` - HTTP API integration
- `0_data/repositories/advice_repository_implementation.dart` - Repository implementation

#### Modified Files

- `1_domain/entities/advice_entity.dart` - Enhanced for model inheritance
- `1_domain/usecases/advice_uscases.dart` - Simplified with repository delegation
- `pubspec.yaml` - Added HTTP package dependency

#### Deleted Files

- `0_data/.gitkeep` - Removed placeholder file

### Learning Outcomes

- **Clean Architecture**: Complete 3-layer implementation with proper dependencies
- **Repository Pattern**: Data access abstraction with interface segregation
- **Data Modeling**: JSON serialization and API response mapping
- **HTTP Integration**: RESTful API consumption with error handling
- **Dependency Inversion**: Domain interfaces implemented by data layer
- **Error Propagation**: Seamless error handling across architectural layers

### Next Steps

- Implement local data source for caching mechanism
- Add dependency injection container (GetIt or Injectable)
- Create data source switching logic (remote vs local)
- Add unit tests for data layer components
- Implement connection checking for offline support
- Add data refresh and retry mechanisms

---

## July 19, 2025 - Error Handling with Dartz Either Pattern

**Commit:** `f2ec205` - "added dartz package to implement Either in getAdvice."  
**Branch:** `dev`  
**Author:** Pablo Marquez  
**Date:** July 19, 2025

### Summary

Implemented comprehensive error handling using the Dartz Either pattern for functional programming approach to failure management. Added failure classes, repository pattern foundation, and updated use cases to return Either<Failure, Success> types for robust error handling throughout the domain layer.

### Key Changes

#### 🆕 New Features

- **Failure Classes**: Created comprehensive failure hierarchy for different error types
  - `ServerFailure`: For API and server-related errors
  - `CacheFailure`: For local storage and caching issues
  - `NetworkFailure`: For connectivity problems
  - `GeneralFailure`: For unexpected errors

- **Either Pattern**: Integrated functional error handling using Dartz
  - Use cases now return `Either<Failure, Entity>` types
  - Eliminates exception throwing in favor of explicit error handling
  - Allows for better composability and testing

- **Repository Foundation**: Started repository pattern implementation
  - `AdviceRepository` class with interface structure
  - Prepared for data source abstraction layer

#### 🏗️ Architecture

- **Functional Error Handling**: Implemented Either pattern for clean error management

```dart
// Failure hierarchy with inheritance
abstract class Failure {
  final String message;
  Failure({this.message = "An unexpected error occurred."});
}

class ServerFailure extends Failure {
  ServerFailure({required String message}) : super(message: message);
}

class CacheFailure extends Failure {
  CacheFailure({required String message}) : super(message: message);
}

class NetworkFailure extends Failure {
  NetworkFailure({required String message}) : super(message: message);
}

class GeneralFailure extends Failure {
  GeneralFailure({required String message}) : super(message: message);
}
```

- **Updated Use Cases with Either Pattern**:

```dart
class AdviceUscases {
  Future<Either<Failure, AdviceEntity>> getAdvice() async {
    // TODO call a repository or an API to get the advice or failure
    // manipulate the data as needed
    // For now, we will return a fake advice after a delay to simulate a network call

    // Simulate a network call or some business logic to get advice
    await Future.delayed(const Duration(seconds: 2));
    
    // Example of returning a failure for testing
    return Left(ServerFailure(
      message: 'Failed to get advice',
    ));
    
    // Success case would be:
    // return Right(AdviceEntity(
    //   id: '1',
    //   advice: 'Stay positive and keep pushing forward!',
    // ));
  }
}
```

- **Cubit Error Handling Integration**:

```dart
class AdvicerCubit extends Cubit<AdvicerCubitState> {
  AdvicerCubit() : super(AdvicerInitial());
  AdviceUscases adviceUscases = AdviceUscases();

  void adviceRequested() async {
    emit(AdvicerStateLoading());
    final result = await adviceUscases.getAdvice();
    result.fold(
      (failure) => emit(AdvicerStateError(message: _mapFailureToMessage(failure))),
      (advice) => emit(AdvicerStateLoaded(advice: advice)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return generalFailureMessage;
    }
  }
}
```

#### 📱 App Structure Updates

- **Domain Layer Enhancement**: Added failures directory to domain structure
  - `1_domain/failures/failures.dart` for error definitions
  - `1_domain/repositories/advice_repository.dart` for data abstraction
  - Clean separation of error handling concerns

- **Dependency Addition**: Added Dartz package for functional programming
  - `dartz: ^0.10.1` in pubspec.yaml
  - Enables Either, Option, and other functional types

#### 🔧 Technical Details

- **Dartz Integration**: Functional programming patterns for error handling
  - `Either<L, R>` type for representing success or failure
  - `Left` for failures, `Right` for successful results
  - `fold()` method for pattern matching and handling both cases

- **Error Message Mapping**: Centralized error message handling
  - Constant error messages for user-friendly display
  - Type-based failure mapping for specific error scenarios
  - Consistent error presentation across the application

- **Repository Pattern Preparation**: Foundation for data layer abstraction
  - Interface-based design for testability
  - Separation of data sources from business logic
  - Prepared for multiple data source implementations

```dart
// Error message constants
const String generalFailureMessage = 'Unexpected Error Occurred';
const String serverFailureMessage = 'Something went wrong with the server, please try again';
const String cacheFailureMessage = 'Something went wrong with the cache, please try again';
```

### Files Added/Modified

#### New Files

- `3_advicer/lib/1_domain/failures/failures.dart` - Failure class hierarchy
- `3_advicer/lib/1_domain/repositories/advice_repository.dart` - Repository pattern foundation

#### Modified Files

- `3_advicer/lib/1_domain/usecases/advice_uscases.dart` - Either pattern implementation
- `3_advicer/lib/2_application/pages/advice/cubit/advicer_cubit.dart` - Error handling integration
- `3_advicer/pubspec.yaml` - Added Dartz dependency

### Learning Outcomes

- **Functional Programming**: Understanding Either pattern for error handling
- **Clean Architecture**: Proper failure management in domain layer
- **Error Handling Patterns**: Moving from exceptions to explicit error types
- **Repository Pattern**: Foundation for data abstraction layer
- **Type Safety**: Compile-time guarantees for error handling
- **Dartz Library**: Functional programming utilities in Dart

### Next Steps

- Complete repository implementation with actual data sources
- Add data source interfaces for API and cache layers
- Implement dependency injection for better testability
- Add unit tests for failure scenarios
- Create data models for API integration
- Implement actual network calls with proper error handling

---

## July 19, 2025 - Domain Layer Architecture Implementation

**Commit:** `7f69aa8` - "created advice entity and advice usecases"  
**Branch:** `dev`  
**Author:** Pablo Marquez  
**Date:** July 19, 2025

### Summary

Implemented the domain layer architecture for the Advicer app, establishing proper Clean Architecture patterns with domain entities and use cases. This foundational work separates business logic from presentation and prepares the app for scalable data management.

### Key Changes

#### 🆕 New Features

- **Domain Entity**: Created `AdviceEntity` as the core business model
  - Immutable data structure with `id` and `advice` properties
  - Extends Equatable for value comparison and testing
  - Provides foundation for advice data throughout the app

- **Use Cases Layer**: Implemented `AdviceUscases` with business logic
  - Asynchronous `getAdvice()` method with simulated network delay
  - Encapsulates business rules for advice retrieval
  - Returns properly structured domain entities

#### 🏗️ Architecture

- **Clean Architecture Implementation**: Established proper domain layer following Clean Architecture principles

```dart
// Domain Entity with Equatable for value comparison
class AdviceEntity extends Equatable {
  final String id;
  final String advice;

  const AdviceEntity({
    required this.id,
    required this.advice,
  });

  @override
  String toString() {
    return 'AdviceEntity(id: $id, advice: $advice';
  }

  @override
  List<Object?> get props => [advice, id];
}
```

```dart
// Use Cases with business logic encapsulation
class AdviceUscases {
  Future<AdviceEntity> getAdvice() async {
    // TODO call a repository or an API to get the advice or failure
    // manipulate the data as needed
    // For now, we will return a fake advice after a delay to simulate a network call

    // Simulate a network call or some business logic to get advice
    await Future.delayed(const Duration(seconds: 2));
    return const AdviceEntity(
      id: '1',
      advice: 'Stay positive and keep pushing forward!',
    );
  }
}
```

- **State Management Integration**: Updated Cubit to use domain entities

```dart
class AdvicerCubit extends Cubit<AdvicerCubitState> {
  AdvicerCubit() : super(AdvicerInitial());
  AdviceUscases adviceUscases = AdviceUscases();

  void adviceRequested() async {
    emit(AdvicerStateLoading());
    try {
      final advice = await adviceUscases.getAdvice();
      emit(AdvicerStateLoaded(advice: advice));
    } catch (e) {
      emit(AdvicerStateError(message: e.toString()));
    }
  }
}
```

```dart
// Updated state classes to work with domain entities
class AdvicerStateLoaded extends AdvicerCubitState {
  final AdviceEntity advice;
  const AdvicerStateLoaded({required this.advice});

  @override
  List<Object?> get props => [advice];
}

class AdvicerStateError extends AdvicerCubitState {
  final String message;
  const AdvicerStateError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
```

#### 📱 App Structure Updates

- **Domain Layer Organization**: Proper folder structure following Clean Architecture
  - `1_domain/entities/` for business models
  - `1_domain/usecases/` for business logic
  - Clear separation from application and presentation layers

- **Dependency Integration**: Updated application layer to consume domain layer
  - Cubit now imports and uses domain entities
  - Use cases injected into state management
  - Proper error handling structure in place

#### 🔧 Technical Details

- **Equatable Integration**: Domain entities extend Equatable for:
  - Value-based equality comparison
  - Improved testing capabilities
  - Better state management performance
  - Debugging support with proper toString() methods

- **Async Architecture**: Use cases designed for asynchronous operations
  - Future-based return types
  - Proper error handling structure
  - Simulation of real-world network calls

- **Type Safety**: Strong typing throughout the domain layer
  - Required parameters for entity construction
  - Immutable data structures
  - Clear interfaces for use cases

### Files Added/Modified

#### New Files
- `3_advicer/lib/1_domain/entities/advice_entity.dart` - Core business entity
- `3_advicer/lib/1_domain/usecases/advice_uscases.dart` - Business logic layer

#### Modified Files
- `3_advicer/lib/2_application/pages/advice/advice_page.dart` - Updated to use domain entities
- `3_advicer/lib/2_application/pages/advice/bloc/advicer_bloc.dart` - Domain layer integration
- `3_advicer/lib/2_application/pages/advice/cubit/advicer_cubit.dart` - Use cases integration
- `3_advicer/lib/2_application/pages/advice/cubit/advicer_state.dart` - Entity-based states

### Learning Outcomes

- **Clean Architecture**: Reinforced understanding of domain-driven design principles
- **Separation of Concerns**: Clear boundaries between domain and application layers
- **Entity Design**: Proper immutable data structures with value equality
- **Use Cases Pattern**: Encapsulation of business logic in dedicated classes
- **Equatable Usage**: Value comparison and state management optimization
- **Future/Async Patterns**: Asynchronous business logic implementation

### Next Steps

- Implement repository pattern for data access abstraction
- Add proper failure handling with Either pattern or custom exceptions
- Create data source interfaces for external API integration
- Add unit tests for domain entities and use cases
- Implement dependency injection for better testability

---

## July 19, 2025 - Column Display Page Implementation

**Commit:** `0c4927c` - "created column display page"  
**Branch:** `3.1_advicer_with_changes`  
**Author:** Pablo Marquez  
**Date:** May 19, 2025

### Summary

Implemented a new column display feature in the Advicer app, adding a second page with navigation functionality and BLoC state management for displaying a list of checkable items.

### Key Changes

#### 🆕 New Features

- **Bottom Navigation System**: Created `RootBottomNavigation` with IndexedStack for seamless page switching

  - Two tabs: Advice page (add icon) and Column Display page (list icon)
  - Proper icon color states based on active tab

- **Column Display Page**: New feature page with complete BLoC architecture

  - Displays a scrollable list of 10 items with checkboxes
  - Each item can be toggled independently
  - Loading state with 3-second delay simulation
  - Error handling structure (commented out)

- **Custom Item Widget**: Reusable `CustomItem` component
  - Card-based design with rounded corners and elevation
  - Checkbox interaction (both tap on checkbox and entire item)
  - Proper state management for checked/unchecked states

#### 🏗️ Architecture

- **BLoC Pattern Implementation**:
  - `ColumnDisplayBloc`: Handles business logic with simulated async operations
  - `ColumnDisplayEvent`: Event-driven architecture
  - `ColumnDisplayState`: Immutable state management with Equatable
  - States: Initial, Loading, Loaded (with data), Error

```dart
// BLoC implementation with async simulation
class ColumnDisplayBloc extends Bloc<ColumnDisplayEvent, ColumnDisplayState> {
  ColumnDisplayBloc() : super(ColumnDisplayInitial()) {
    on<ColumnDisplayEvent>((event, emit) async {
      emit(ColumnDisplayLoading());
      // Simulate business logic / API call
      debugPrint('fake get items triggered');
      await Future.delayed(const Duration(seconds: 3), () {});
      debugPrint('got items');
      emit(const ColumnDisplayLoaded(data: [
        MapEntry('item 1', false),
        MapEntry('item 2', true),
        // ... more items
      ]));
    });
  }
}
```

```dart
// State management with Equatable
@immutable
abstract class ColumnDisplayState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ColumnDisplayLoaded extends ColumnDisplayState {
  final List<MapEntry<String, bool>> data;
  const ColumnDisplayLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}
```

#### 🎨 UI/UX Improvements

- **Navigation**: Bottom navigation bar for switching between pages
- **Theme Integration**: Consistent with existing app theming
- **Responsive Design**: Proper use of IndexedStack for memory efficiency
- **Material Design**: Cards, proper spacing, and visual hierarchy

```dart
// Bottom Navigation with IndexedStack for state preservation
class _RootBottomNavigationState extends State<RootBottomNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: const [
        AdvicerPageWrapperProvider(key: Key('advicer_page')),
        ColumnDisplayPageWrapperProvider(key: Key('column_display_page')),
      ]),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.add,
                color: _currentIndex == 0
                  ? Theme.of(context).iconTheme.color
                  : Theme.of(context).colorScheme.onSurface.withAlpha(120),
              ),
              onPressed: () => setState(() => _currentIndex = 0),
            ),
            // ... second tab
          ],
        ),
      ),
    );
  }
}
```

```dart
// Custom Item Widget with interactive elements
class CustomItem extends StatefulWidget {
  final String title;
  final bool isChecked;

  const CustomItem({
    super.key,
    required this.title,
    this.isChecked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
        trailing: Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() => isChecked = value ?? false);
          },
        ),
        onTap: () => setState(() => isChecked = !isChecked),
      ),
    );
  }
}
```

#### 📱 App Structure Updates

- Modified `main.dart` to use `RootBottomNavigation` as root widget
- Updated theme configurations
- Enhanced project structure with new page organization

#### 🔧 Technical Details

- **State Persistence**: IndexedStack maintains state across tab switches
- **Provider Integration**: Wrapped pages with BlocProvider
- **Async Simulation**: 3-second delay to simulate real data fetching
- **Memory Management**: Proper widget key usage for state preservation

```dart
// BLoC Provider Wrapper for dependency injection
class ColumnDisplayPageWrapperProvider extends StatelessWidget {
  const ColumnDisplayPageWrapperProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = ColumnDisplayBloc();
        bloc.add(ColumnDisplayRequestEvent()); // Trigger once on creation
        return bloc;
      },
      child: const ColumnDisplayPage(),
    );
  }
}
```

```dart
// State handling in the main page with BlocBuilder
class ColumnDisplayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Column Display')),
      body: BlocBuilder<ColumnDisplayBloc, ColumnDisplayState>(
        builder: (context, state) {
          if (state is ColumnDisplayLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ColumnDisplayLoaded) {
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final item = state.data[index];
                return CustomItem(
                  title: item.key,
                  isChecked: item.value,
                );
              },
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
```

### Learning Outcomes

- **BLoC Pattern**: Reinforced understanding of event-driven state management
- **Flutter Navigation**: Implemented bottom navigation with IndexedStack
- **Custom Widgets**: Created reusable, stateful components
- **App Architecture**: Structured clean code with separation of concerns
- **State Management**: Proper handling of widget state and BLoC integration

### Next Steps

- Add real data source integration
- Implement item persistence
- Add item creation/deletion functionality
- Enhance error handling and user feedback
- Consider adding animations and transitions

---

_This log entry documents the implementation of a complete feature from UI to state management, showcasing Flutter best practices and clean architecture patterns._
