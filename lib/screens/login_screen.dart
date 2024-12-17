// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rablo_chat/constants.dart';
import 'package:rablo_chat/screens/home_screen.dart';
import 'package:rablo_chat/screens/registration_screen.dart';
import 'package:rablo_chat/service/firebase_service.dart';
import 'package:rablo_chat/widgets/reusable_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    final result = await FirebaseService()
        .login(email: emailController.text, password: passwordController.text);
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        'SignUp Successfull',
        style: kButtonTitleStyle(),
      )));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
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
          'Login',
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
              height: 300,
              width: 300,
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
                title: 'Login',
                onPressed: () {
                  login();
                }),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "I don't have an account?",
                  style: kCommonTextStyle(),
                ),
                const SizedBox(width: 5),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationScreen()));
                  },
                  child: Text(
                    'Sign Up',
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
