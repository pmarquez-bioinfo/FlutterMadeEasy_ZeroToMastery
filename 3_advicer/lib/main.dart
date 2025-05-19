import 'package:advicer/2_application/pages/advice/advice_page.dart';
import 'package:advicer/2_application/pages/columnDisplay/column_display_page.dart';
import 'package:advicer/2_application/root_bottom_navigation.dart';
import 'package:advicer/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '2_application/core/services/theme_service.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeService(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(builder: (context, themeService, child) {
      return MaterialApp(
        themeMode: themeService.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        // home: const AdvicerPageWrapperProvider(),
        home: const RootBottomNavigation(),
        routes: <String, WidgetBuilder>{
          '/root': (BuildContext context) => const RootBottomNavigation(),
          '/screenOne': (BuildContext context) => const AdvicerPageWrapperProvider(),
          '/screenTwo': (BuildContext context) => const ColumnDisplayPageWrapperProvider(),
        },
      );
    });
  }
}
