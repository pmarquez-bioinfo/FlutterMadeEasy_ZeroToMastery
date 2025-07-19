import 'package:flutter/material.dart';

class HelloWorld extends StatelessWidget {
  const HelloWorld({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    debugDumpFocusTree();
    return Center(
      child: Focus(
        debugLabel: 'Hello World Focus Widget',
        descendantsAreFocusable: true,
        descendantsAreTraversable: true,
        canRequestFocus: true,
        skipTraversal: false,
        autofocus: true,
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            debugPrint('Hello World widget has focus');
          } else {
            debugPrint('Hello World widget lost focus');
          }
        },
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
          child: const Center(
            child: Text('Hello World there!', style: TextStyle(color: Colors.red, fontSize: 20)),
          ),
        ),
      ),
    );
  }
}
