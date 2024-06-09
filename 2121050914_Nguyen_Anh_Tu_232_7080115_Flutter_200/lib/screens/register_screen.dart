import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/auth/auth_service.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final void Function()? onTap;
  RegisterPage({
    super.key,
    this.onTap,
  });

  Future<void> register(BuildContext context) async {
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
                  prefixIcon: Icons.email,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    hintText: 'Password',
                    obscureText: false,
                    controller: passwordController,
                    prefixIcon: Icons.lock),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    hintText: 'Confirm password',
                    obscureText: false,
                    controller: confirmPasswordController,
                    prefixIcon: Icons.lock),
                const SizedBox(
                  height: 25,
                ),
                MyButton(
                  text: 'Register',
                  ontap: () {
                    if (_formKey.currentState!.validate()) {
                      register(context);
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
                      'Already have an account? ',
                      style: TextStyle(color: Colors.white),
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
          ),
        ],
      ),
    );
  }
}
