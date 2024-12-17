// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:rablo_chat/constants.dart';

class ReusableButton extends StatelessWidget {
  const ReusableButton(
      {super.key, required this.title, required this.onPressed});
  final String title;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: kButtonTitleStyle(),
      ),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
    );
  }
}
