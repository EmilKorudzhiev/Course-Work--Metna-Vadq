import 'package:MetnaVadq/assets/colors.dart';
import 'package:MetnaVadq/features/auth/screens/login_page.dart';
import 'package:MetnaVadq/features/navigation_bar/notifier/navigation_notifier.dart';
import 'package:MetnaVadq/features/posts/screens/feed.dart';
import 'package:MetnaVadq/features/user/screens/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationBarWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavigationBarState();
}

class _NavigationBarState extends ConsumerState<NavigationBarWidget> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const FeedPage(),
    ProfilePage(),
  ];

  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var navIndex = ref.watch(navProvider);
    return Scaffold(
      body: Center(
        child: _widgetOptions[navIndex.index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navIndex.index,
        onTap: (value) {
          ref.read(navProvider.notifier).onIndexChanged(value);
        },
        elevation: 10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: AppColors.primary,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: AppColors.primaryAccent,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              activeIcon: Icon(Icons.person_2),
              label: "Home"),
        ],
      ),
    );
  }
}
