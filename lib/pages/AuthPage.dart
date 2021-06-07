import 'package:diplom_app/auth/FormPicker.dart';
import 'package:diplom_app/models/AuthModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthModel(),
      child: Scaffold(body: AuthFormPicker()),
    );
  }
}
