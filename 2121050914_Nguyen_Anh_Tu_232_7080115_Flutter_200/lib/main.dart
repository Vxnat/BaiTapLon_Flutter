import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/provider/provider_food.dart';
import 'package:flutter_application_e_commerce_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAgLys-HGRd6pqNHzVNxXsjN1NbrGP3rP4',
          appId: '8785517145:android:74823752a782e393d0ef48',
          messagingSenderId: '8785517145',
          projectId: 'food-app-37b37'));
  runApp(ChangeNotifierProvider(
      create: (context) => ProviderFood(),
      child: const MaterialApp(
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      )));
}
