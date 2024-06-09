import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_e_commerce_app/API/apis.dart';
import 'package:flutter_application_e_commerce_app/auth/auth_service.dart';
import 'package:flutter_application_e_commerce_app/components/my_text_box.dart';
import 'package:flutter_application_e_commerce_app/modules/user_food.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final usersCollection = FirebaseFirestore.instance.collection('users');

  Future<dynamic> showLogoutMessage() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Log out',
            style: TextStyle(color: Colors.redAccent),
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                logout();
              },
              child: const Text(
                'Logout',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> editField(String field) async {
    String newValue = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          cursorColor: Colors.grey,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              hintText: 'Enter new $field',
              hintStyle: const TextStyle(color: Colors.grey)),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              )),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(newValue);
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );

    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(APIs.user.uid).update({field: newValue});
    }
  }

  // Thoát tài khoản
  void logout() {
    final auth = AuthService();
    auth.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[430],
        appBar: AppBar(
          title: const Text(
            'My profile',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          backgroundColor: Colors.orange,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: showLogoutMessage,
                icon: const Icon(
                  Icons.output,
                  color: Colors.redAccent,
                ))
          ],
        ),
        body: StreamBuilder(
          stream: APIs.getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => UserFood.fromJson(e.data())).toList() ?? [];
              final user = list[0];
              return ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    'img/user_img.png',
                    height: 70,
                    width: 70,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    user.email,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      'My Details',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  MyTextBox(
                    text: user.name,
                    sectionName: 'username',
                    onPressed: () => editField('name'),
                  ),
                  // MyTextBox(
                  //   text: userData['bio'],
                  //   sectionName: 'bio',
                  //   onPressed: () => editField('bio'),
                  // ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error${snapshot.error}'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          },
        ));
  }
}
