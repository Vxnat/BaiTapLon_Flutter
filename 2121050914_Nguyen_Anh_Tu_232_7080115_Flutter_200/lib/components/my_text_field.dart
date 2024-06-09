// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final IconData prefixIcon;
  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: Colors.orange,
        style: const TextStyle(color: Colors.black54),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Không được để trống!';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 255, 184, 118)),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.orange)),
            fillColor: const Color.fromARGB(255, 255, 237, 210),
            filled: true,
            hintText: hintText,
            prefixIcon: Icon(
              prefixIcon,
              color: Colors.orangeAccent,
            ),
            hintStyle: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
