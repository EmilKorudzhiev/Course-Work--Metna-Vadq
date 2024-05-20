
import 'package:MetnaVadq/features/auth/models/register_request.dart';
import 'package:MetnaVadq/features/auth/screens/login_page.dart';
import 'package:MetnaVadq/features/auth/service/auth_controller.dart';
import 'package:MetnaVadq/features/navigation_bar/widgets/navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:MetnaVadq/assets/colors.dart';
import 'package:MetnaVadq/features/auth/screens/auth_widgets.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late Size mediaSize;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.primary,
          image: DecorationImage(
            image: AssetImage("lib/assets/pictures/registerPic.jpg"),
            fit: BoxFit.cover,
            colorFilter:
            ColorFilter.mode(AppColors.primaryAccent, BlendMode.dstATop),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(children: [
            Positioned(bottom: 0, child: _buildBottom()),
          ]),
        ),
      ),
    );
  }


  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Добре дошли!",
          style: TextStyle(
              color: Colors.black, fontSize: 32, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        AuthWidgets.buildGreyText("Име"),
        AuthWidgets.buildInputField(firstNameController),
        const SizedBox(height: 20),
        AuthWidgets.buildGreyText("Фамилия"),
        AuthWidgets.buildInputField(lastNameController),
        const SizedBox(height: 20),
        AuthWidgets.buildGreyText("Имейл"),
        AuthWidgets.buildInputField(emailController),
        const SizedBox(height: 20),
        AuthWidgets.buildGreyText("Парола"),
        AuthWidgets.buildInputField(passwordController, isPassword: true),
        const SizedBox(height: 20),
        _buildRegisterButton(),
        const SizedBox(height: 20),
        _buildRedirectText()
      ],
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () {
        if (firstNameController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Моля въведете име.'),
              duration: Duration(seconds: 2),
            ),
          );
        } else if (firstNameController.text.length < 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Името трябва да бъде поне 3 символа.'),
              duration: Duration(seconds: 2),
            ),
          );
        } else if (lastNameController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Моля въведете фамилия.'),
              duration: Duration(seconds: 2),
            ),
          );
        } else if (lastNameController.text.length < 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Фамилията трябва да бъде поне 3 символа.'),
              duration: Duration(seconds: 2),
            ),
          );
        } else if (emailController.text.isEmpty) {
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
        } else if (passwordController.text.length < 8) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Паролата трябва да бъде поне 8 символа.'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ref
              .read(authProvider.notifier)
              .register(RegisterRequest(
              firstNameController.text,
              lastNameController.text,
              emailController.text,
              passwordController.text))
              .then((value) => {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Регистрацията е успешна!'),
                duration: Duration(seconds: 2),
              ),
            ),
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NavigationBarWidget()))
          });
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: AppColors.primaryAccent,
        textStyle: const TextStyle(
          fontSize: 18
        ),
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: AppColors.secondaryAccent,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("Регистриране"),
    );
  }

  Widget _buildRedirectText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Вече имате регистрация? "),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text(
            'Влезте от тук.',
            style: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}