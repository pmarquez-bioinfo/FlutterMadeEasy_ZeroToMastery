import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(title: const Text('Counter App')),
      body: Center(
        child: Text(
          _counter.toString(),
          style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: _counter > 0 ? Theme.of(context).primaryColor : Colors.black),
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
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: const Icon(Icons.remove)),
            FloatingActionButton(
                heroTag: 'btn2',
                onPressed: () {
                  setState(() {
                    _counter = _counter + 1;
                  });
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.add)),
          ],
        ),
      ),
    );
  }
}
