import 'package:MetnaVadq/features/auth/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:MetnaVadq/assets/colors.dart';
import 'package:MetnaVadq/features/auth/screens/auth_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
        /// TODO da
        debugPrint("FName : ${firstNameController.text}");
        debugPrint("LName : ${lastNameController.text}");
        debugPrint("Email : ${emailController.text}");
        debugPrint("Password : ${passwordController.text}");
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
        Text("Вече имате регистрация? "),
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