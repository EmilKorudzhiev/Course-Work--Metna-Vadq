import 'package:MetnaVadq/features/auth/providers/auth_providers.dart';
import 'package:MetnaVadq/features/auth/screens/login_page.dart';
import 'package:MetnaVadq/features/posts/screens/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:MetnaVadq/assets/colors.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    ref.read(authProvider).isLoggedIn().then((value) => {
          Future.delayed(Duration(seconds: 2), () async {
            if (value) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const FeedPage()));
            } else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginPage()));
            }
          })
        });

    /// TODO fix this check
    // SecureStorageManager secureStorageManager = SecureStorageManager();
    // Future.delayed(Duration(seconds: 2), () async {
    //   if (await secureStorageManager.areTokensSet()) {
    //     Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(builder: (_) => const FeedPage()));
    //   } else {
    //     Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(builder: (_) => const LoginPage()));
    //   }
    //});
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
              'lib/assets/pictures/MV_Logo_Large.svg',
              height: 250,
              width: 250,
            ),
          ],
        ),
      ),
    );
  }
}
