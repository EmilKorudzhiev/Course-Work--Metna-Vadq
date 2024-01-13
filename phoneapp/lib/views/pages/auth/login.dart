import 'package:MetnaVadq/blocs/auth_controller.dart';
import 'package:MetnaVadq/views/pages/app/feed.dart';
import 'package:MetnaVadq/views/pages/auth/register.dart';
import 'package:MetnaVadq/views/widgets/auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:MetnaVadq/utils/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        image: DecorationImage(
          image: AssetImage("lib/utils/images/loginPic.jpg"),
          fit: BoxFit.cover,
          colorFilter:
          ColorFilter.mode(AppColors.primaryAccent, BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 50, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: Center(
        child: SvgPicture.asset(
          'lib/utils/images/MV_Logo_Large.svg',
          height: 220,
          width: 220,
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
        const SizedBox(height: 40),
        AuthWidgets.buildGreyText("Имейл"),
        AuthWidgets.buildInputField(emailController),
        const SizedBox(height: 40),
        AuthWidgets.buildGreyText("Парола"),
        AuthWidgets.buildInputField(passwordController, isPassword: true),
        const SizedBox(height: 20),
        _buildLoginButton(),
        const SizedBox(height: 10),
        _buildRedirectText()
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        debugPrint("Email : ${emailController.text}");
        debugPrint("Password : ${passwordController.text}");
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const FeedPage()));
        AuthController.loginUser(emailController.text, passwordController.text);
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
      child: const Text("Влизане"),
    );
  }

  Widget _buildRedirectText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Нямате регистрация? "),
        GestureDetector(
           onTap: () {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const RegisterPage()),
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
    );
  }

}