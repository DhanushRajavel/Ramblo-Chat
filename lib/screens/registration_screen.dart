// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rablo_chat/constants.dart';
import 'package:rablo_chat/screens/login_screen.dart';
import 'package:rablo_chat/service/firebase_service.dart';
import 'package:rablo_chat/widgets/reusable_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  void signUp() async {
    String? result = await FirebaseService().signUp(
        name: nameController.text,
        mobile: mobileController.text,
        email: emailController.text,
        password: passwordController.text);
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        'SignUp Successfull',
        style: kButtonTitleStyle(),
      )));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        'SignUp Failed',
        style: kButtonTitleStyle(),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Register',
          style: kAppBarTitleStyle(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'images/rablo_logo.png',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Your Name',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Your Mobile Number',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Your Email',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Your Password',
              ),
            ),
            const SizedBox(height: 20),
            ReusableButton(
              title: 'Register',
              onPressed: () {
                signUp();
              },
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: kCommonTextStyle(),
                ),
                const SizedBox(width: 5),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    'Login',
                    style:
                        kCommonTextStyle().copyWith(color: Colors.blueAccent),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
