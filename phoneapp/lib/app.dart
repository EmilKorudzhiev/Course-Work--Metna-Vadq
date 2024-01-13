import 'package:flutter/material.dart';
import 'package:MetnaVadq/views/pages/app/feed.dart';
import 'package:MetnaVadq/views/pages/auth/login.dart';
import 'package:MetnaVadq/views/pages/auth/register.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
        home: LoginPage()
    );
  }
}