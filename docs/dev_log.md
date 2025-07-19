# Flutter Development Log

This document tracks the development progress and changes made to the Flutter Made Easy Zero to Mastery course projects.

## 🚀 Roadmap & Next Work

### Current Sprint

- [ ] **Domain Layer Implementation**: Create proper domain entities for advice data
- [ ] **iOS Home Widget**: Develop iOS home screen widget to display advice
- [ ] **Entity Architecture**: Structure advice models with proper data validation

### Backlog

- [ ] Add real data source integration
- [ ] Implement item persistence for column display
- [ ] Add item creation/deletion functionality
- [ ] Enhance error handling and user feedback
- [ ] Consider adding animations and transitions
- [ ] Implement advice caching mechanism
- [ ] Add unit tests for BLoC components

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
