import 'package:MetnaVadq/views/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:MetnaVadq/views/pages/app/feed.dart';
import 'package:MetnaVadq/views/pages/auth/login_page.dart';
import 'package:MetnaVadq/views/pages/auth/register_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
        home: SplashScreen(),
    );
  }
}