import 'package:flutter/material.dart';
import 'package:flutterbasics/application/theme_service.dart';
import 'package:flutterbasics/presentation/navigation_example_screens/screen_one.dart';
import 'package:flutterbasics/presentation/navigation_example_screens/screen_two.dart';
import 'package:flutterbasics/root_bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:json_theme/json_theme.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'dart:convert'; // For jsonDecode

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeService(),
    child: MyApp(theme: theme),
  ));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  const MyApp({super.key, required this.theme});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(builder: (context, themeService, child) {
      return MaterialApp(
        themeMode: themeService.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        theme: theme,
        // theme: AppTheme.lightTheme,
        // darkTheme: AppTheme.darkTheme,
        home: const RootBottomNavigation(),
        routes: <String, WidgetBuilder>{
          '/root': (BuildContext context) => const RootBottomNavigation(),
          '/screenOne': (BuildContext context) => const ScreenOne(),
          '/screenTwo': (BuildContext context) => const ScreenTwo(),
        },
      );
    });
  }
}
