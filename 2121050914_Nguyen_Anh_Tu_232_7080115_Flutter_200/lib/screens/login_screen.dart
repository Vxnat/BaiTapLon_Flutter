import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/auth/auth_service.dart';
import 'package:flutter_application_e_commerce_app/components/my_text_field.dart';
import '../components/my_button.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  Future<void> login(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.signInWithEmailPasword(
          emailController.text, passwordController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Image.asset(
            'img/logo.png',
            width: 250,
            height: 250,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Welcome back , you\'have been missed!',
            style: TextStyle(color: Colors.orange, fontSize: 16),
          ),
          const SizedBox(
            height: 25,
          ),
          MyTextField(
            hintText: 'Email',
            obscureText: false,
            controller: emailController,
          ),
          const SizedBox(
            height: 10,
          ),
          MyTextField(
            hintText: 'Password',
            obscureText: true,
            controller: passwordController,
          ),
          const SizedBox(
            height: 25,
          ),
          MyButton(
            text: 'Login',
            ontap: () => login(context),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Not a member? ',
                style: TextStyle(color: Colors.grey),
              ),
              GestureDetector(
                onTap: onTap,
                child: const Text(
                  'Register now',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
