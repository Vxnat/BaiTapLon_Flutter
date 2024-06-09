import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_e_commerce_app/auth/auth_service.dart';
import 'package:flutter_application_e_commerce_app/components/my_text_field.dart';
import '../components/my_button.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'img/background_gate.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'img/logo.png',
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.3,
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
                  prefixIcon: Icons.email,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  hintText: 'Password',
                  obscureText: true,
                  controller: passwordController,
                  prefixIcon: Icons.lock,
                ),
                const SizedBox(
                  height: 25,
                ),
                MyButton(
                  text: 'Login',
                  ontap: () {
                    if (_formKey.currentState!.validate()) {
                      login(context);
                    }
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Not a member? ',
                      style: TextStyle(color: Colors.white),
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
          ),
        ],
      ),
    );
  }
}
