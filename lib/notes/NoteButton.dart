import 'package:flutter/material.dart';

class NoteButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  NoteButton({this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: Color(0xFFF0F0F0),
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 75),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }
}
