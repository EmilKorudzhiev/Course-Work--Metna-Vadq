import 'package:MetnaVadq/features/auth/models/login_request.dart';
import 'package:MetnaVadq/features/auth/screens/register_page.dart';
import 'package:MetnaVadq/features/auth/service/auth_controller.dart';
import 'package:MetnaVadq/features/navigation_bar/widgets/navigation_bar_widget.dart';
import 'package:MetnaVadq/features/posts/screens/feed_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:MetnaVadq/assets/colors.dart';
import 'package:MetnaVadq/features/auth/screens/auth_widgets.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.primary,
          image: DecorationImage(
            image: AssetImage("lib/assets/pictures/loginPic.jpg"),
            fit: BoxFit.cover,
            colorFilter:
                ColorFilter.mode(AppColors.primaryAccent, BlendMode.dstATop),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(children: [
            Positioned(
                bottom: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Добре дошли!",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 40),
                          AuthWidgets.buildGreyText("Имейл"),
                          AuthWidgets.buildInputField(emailController),
                          const SizedBox(height: 40),
                          AuthWidgets.buildGreyText("Парола"),
                          AuthWidgets.buildInputField(passwordController,
                              isPassword: true),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (emailController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Моля въведете имейл.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else if (passwordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Моля въведете парола.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                ref
                                    .read(authProvider.notifier)
                                    .logIn(LoginRequest(emailController.text, passwordController.text))
                                    .then((value) => {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Влизането беше успешно!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  ),
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const NavigationBarWidget()
                                      )
                                  )
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: AppColors.primaryAccent,
                              textStyle: const TextStyle(fontSize: 18),
                              shape: const StadiumBorder(),
                              elevation: 20,
                              shadowColor: AppColors.secondaryAccent,
                              minimumSize: const Size.fromHeight(60),
                            ),
                            child: const Text("Влизане"),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Нямате регистрация? "),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterPage()),
                                    );
                                  },
                                  child: const Text(
                                    'Регистрирайте се тук.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ]),
        ),
      ),
    );
  }
}
