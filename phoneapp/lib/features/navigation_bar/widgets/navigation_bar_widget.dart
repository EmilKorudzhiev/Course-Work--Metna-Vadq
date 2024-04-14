import 'package:MetnaVadq/assets/colors.dart';
import 'package:MetnaVadq/features/navigation_bar/notifier/navigation_notifier.dart';
import 'package:MetnaVadq/features/posts/screens/create_post_page.dart';
import 'package:MetnaVadq/features/posts/screens/feed_page.dart';
import 'package:MetnaVadq/features/search/screens/map_search_page.dart';
import 'package:MetnaVadq/features/user/screens/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationBarWidget extends ConsumerWidget {
  const NavigationBarWidget({super.key});

  static final List<Widget> _widgetOptions = <Widget>[
    const FeedPage(),
    const MapSearchPage(),
    const CreatePostPage(),
    ProfilePage(null),
  ];

  @override
  Widget build(BuildContext context, ref) {
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
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: "MapSearch"),
          BottomNavigationBarItem(
              icon: Icon(Icons.post_add_outlined),
              activeIcon: Icon(Icons.post_add),
              label: "CreatePost"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              activeIcon: Icon(Icons.person_2),
              label: "Profile"),
        ],
      ),
    );
  }
}
