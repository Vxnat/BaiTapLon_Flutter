import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/auth/auth_service.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();
  final void Function()? onTap;
  RegisterPage({
    super.key,
    this.onTap,
  });

  void register(BuildContext context) {
    final auth = AuthService();

    if (passwordController.text == confirmPasswordController.text) {
      try {
        auth.signUpWithEmailPassword(
            emailController.text, passwordController.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Password don\'t match!'),
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
            'Let\'s create an account for you',
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
            height: 10,
          ),
          MyTextField(
            hintText: 'Confirm password',
            obscureText: true,
            controller: confirmPasswordController,
          ),
          const SizedBox(
            height: 25,
          ),
          MyButton(
            text: 'Register',
            ontap: () => register(context),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(color: Colors.grey),
              ),
              GestureDetector(
                onTap: onTap,
                child: const Text(
                  'Login now',
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
