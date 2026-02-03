import 'package:covid_tracker/View/splash_screen.dart';
import 'package:covid_tracker/services/stats_services.dart';
import 'package:covid_tracker/services/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StatsServices()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeSwitch = context.watch<ThemeProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid-19 Tracker',
      themeMode: themeSwitch.isDark ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData(
        colorScheme: .fromSeed(seedColor: Color(0xff2d6a4f)),
        brightness: Brightness.dark,
      ),
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Color(0xff2d6a4f)),
        brightness: Brightness.light,
      ),
      home: const SplashScreen(),
    );
  }
}
