import 'package:flutter/material.dart';
import 'package:flutterbasics/application/theme_service.dart';
import 'package:flutterbasics/presentation/components/custom_button.dart';
import 'package:flutterbasics/presentation/widget_examples/widgets/buttons_example.dart';
import 'package:flutterbasics/presentation/widget_examples/widgets/first_column_child.dart';
import 'package:flutterbasics/presentation/widget_examples/widgets/hello_world.dart';
import 'package:flutterbasics/presentation/widget_examples/widgets/layout_builder_example.dart';
import 'package:flutterbasics/presentation/widget_examples/widgets/media_query_example.dart';
import 'package:flutterbasics/presentation/widget_examples/widgets/person.dart';
import 'package:flutterbasics/presentation/widget_examples/widgets/row_expanded_example.dart';
import 'package:provider/provider.dart';

class WidgetExampleScreen extends StatelessWidget {
  const WidgetExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugDumpFocusTree();
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Basics')),
      body: Column(children: [
        ElevatedButton(
          focusNode: FocusNode(
            debugLabel: 'Elevated Button Focus Node',
            descendantsAreFocusable: true,
            descendantsAreTraversable: true,
            canRequestFocus: true,
            skipTraversal: false,
          ),
          onPressed: () => {},
          child: Text('Elevated Button Example'),
        ),
        Focus(
          focusNode: FocusNode(
            debugLabel: 'Hello World Focus Node',
            descendantsAreFocusable: true,
            descendantsAreTraversable: true,
            canRequestFocus: true,
            skipTraversal: false,
          ),
          debugLabel: 'Hello World Focus Widget',
          descendantsAreFocusable: true,
          descendantsAreTraversable: true,
          canRequestFocus: true,
          skipTraversal: false,
          autofocus: true,
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('Container Example', style: TextStyle(color: Colors.red, fontSize: 20)),
            ),
          ),
        ),
      ]),
    );
  }
}
