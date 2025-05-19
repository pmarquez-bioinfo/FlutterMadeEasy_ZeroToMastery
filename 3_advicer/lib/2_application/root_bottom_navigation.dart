import 'package:advicer/2_application/pages/advice/advice_page.dart';
import 'package:advicer/2_application/pages/columnDisplay/column_display_page.dart';
import 'package:flutter/material.dart';

class RootBottomNavigation extends StatefulWidget {
  const RootBottomNavigation({Key? key}) : super(key: key);

  @override
  State<RootBottomNavigation> createState() => _RootBottomNavigationState();
}

class _RootBottomNavigationState extends State<RootBottomNavigation> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: const [
        AdvicerPageWrapperProvider(
          key: Key('advicer_page'),
        ),
        ColumnDisplayPageWrapperProvider(
          key: Key('column_display_page'),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.add,
                color: _currentIndex == 0 ? Theme.of(context).iconTheme.color : Theme.of(context).colorScheme.onSurface.withAlpha(120),
              ),
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.list, color: _currentIndex == 1 ? Theme.of(context).iconTheme.color : Theme.of(context).colorScheme.onSurface.withAlpha(120)),
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
