import 'package:flutter/material.dart';
import 'package:flutterbasics/application/theme_service.dart';
import 'package:provider/provider.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(builder: ((context, themeService, child) {
      Color primaryColor = themeService.isDarkModeOn ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onPrimary;
      Color secondaryColor = themeService.isDarkModeOn ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onSecondary;

      return Scaffold(
        backgroundColor: themeService.isDarkModeOn ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.onPrimaryContainer,
        appBar: AppBar(title: const Text('Counter App')),
        body: Center(
          child: Text(
            _counter.toString(),
            style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: _counter > 0 ? primaryColor : secondaryColor),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                  heroTag: 'btn1',
                  onPressed: () {
                    setState(() {
                      _counter = _counter - 1;
                    });
                  },
                  backgroundColor: secondaryColor,
                  child: Icon(Icons.remove, color: themeService.isDarkModeOn ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary)),
              FloatingActionButton(
                  heroTag: 'btn2',
                  onPressed: () {
                    setState(() {
                      _counter = _counter + 1;
                    });
                  },
                  backgroundColor: themeService.isDarkModeOn ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onPrimary,
                  child: Icon(Icons.add, color: themeService.isDarkModeOn ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary)),
            ],
          ),
        ),
      );
    }));
  }
}
