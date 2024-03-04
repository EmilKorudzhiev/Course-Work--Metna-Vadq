import 'package:MetnaVadq/features/user/service/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  final int? userId;

  const ProfilePage(this.userId, {super.key});

  
  //TODO MAKE POST LOADING AND PAGE FETCHING ON THEM

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 16),
      top: true,
      child: FutureBuilder(
          future: ref.watch(userControllerProvider).getUserProfile(userId),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var user = snapshot.data!;

            print("USER PROFILE:$user");

            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text("User name"),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12, bottom: 12),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: const CircleAvatar(
                          radius: 75,
                          backgroundImage: NetworkImage(
                              "https://wiki.dave.eu/images/4/47/Placeholder.png"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 12),
                          child: Text(
                              style: TextStyle(fontSize: 20), "Followers: 12"),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 12),
                          child: Text(
                              style: TextStyle(fontSize: 20), "Catches: 231"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: GridView.count(
                        crossAxisCount: 3,
                        children: List.generate(100, (index) {
                          return Center(
                            child: Text(
                              'Item $index',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          );
                        }),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
