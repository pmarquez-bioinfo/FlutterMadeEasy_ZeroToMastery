import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbasics/presentation/counter/conter_screen.dart';
import 'package:flutterbasics/presentation/list/list_screen.dart';
import 'package:flutterbasics/presentation/theme_animation/theme_animation_screen.dart';
import 'package:flutterbasics/presentation/widget_examples/widget_examples_screen.dart';

class RootBottomNavigation extends StatefulWidget {
  const RootBottomNavigation({super.key});

  @override
  State<RootBottomNavigation> createState() => _RootBottomNavigationState();
}

class _RootBottomNavigationState extends State<RootBottomNavigation> {
  int _currentIndex = 0;

  // void _handleKeyEvent(KeyEvent event) {
  //   if (event is KeyDownEvent) {
  //     if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
  //       setState(() {
  //         _currentIndex = (_currentIndex + 1) % 4; // Wrap around to the first tab
  //       });
  //     } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
  //       setState(() {
  //         _currentIndex = (_currentIndex - 1 + 4) % 4; // Wrap around to the last tab
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: IndexedStack(index: _currentIndex, children: const [
        WidgetExampleScreen(),
        // CounterScreen(),
        // ListScreen(),
        // ThemeAnimationScreen(),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'examples'),
          // BottomNavigationBarItem(icon: Icon(Icons.add), label: 'counter'),
          // BottomNavigationBarItem(icon: Icon(Icons.list), label: 'list'),
          // BottomNavigationBarItem(icon: Icon(Icons.color_lens), label: 'theme'),
        ],
      ),
    );
  }
}
