import 'package:diplom_app/models/AuthModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthFormPicker extends StatelessWidget {
  const AuthFormPicker({Key key}) : super(key: key);

  static const _padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: _padding,
        child: Center(child: Consumer<AuthModel>(
          builder: (_, value, __) {
            print(value.verificationId);
            print(value.currentForm);
            return value.currentForm;
          },
        )));
  }
}
