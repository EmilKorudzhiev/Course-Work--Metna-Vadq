import 'package:MetnaVadq/api/auth/secure_storage_manager.dart';
import 'package:MetnaVadq/utils/colors.dart';
import 'package:MetnaVadq/views/pages/app/feed.dart';
import 'package:MetnaVadq/views/pages/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SecureStorageManager secureStorageManager = SecureStorageManager();
    Future.delayed(Duration(seconds: 2), () async {
      if (await secureStorageManager.areTokensSet()) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const FeedPage()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            AppColors.primary,
            AppColors.primaryAccent,
            AppColors.secondaryAccent,
            AppColors.secondary
          ], begin: Alignment.topRight, end: Alignment.bottomLeft),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'lib/utils/images/MV_Logo_Large.svg',
              height: 250,
              width: 250,
            ),
          ],
        ),
      ),
    );
  }
}
