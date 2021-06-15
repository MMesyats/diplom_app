import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  SendButton({this.title, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Color(0xFF4184E9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }
}
