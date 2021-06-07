import 'dart:convert';

import 'package:diplom_app/auth/UserForm.dart';
import 'package:diplom_app/models/AuthModel.dart';
import 'package:diplom_app/models/User.dart';
import 'package:diplom_app/services/Backend.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmsForm extends StatefulWidget {
  SmsForm({Key key}) : super(key: key);
  final _smsController = TextEditingController();

  @override
  _SmsFormState createState() => _SmsFormState();
}

class _SmsFormState extends State<SmsForm> {
  verifySms() async {
    final authModel = Provider.of<AuthModel>(context, listen: false);
    final authCredential = fb.PhoneAuthProvider.credential(
        verificationId: authModel.verificationId,
        smsCode: widget._smsController.text);
    await fb.FirebaseAuth.instance.signInWithCredential(authCredential);

    try {
      User user = await Backend.getUserInfo();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', jsonEncode(user.toJson()));
      Navigator.of(context).pushNamed('/home');
    } catch (e) {
      authModel.currentForm = UserForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          decoration: InputDecoration(hintText: "111111"),
          controller: widget._smsController,
          inputFormatters: [TextInputMask(mask: '999999')],
        ),
        TextButton(onPressed: verifySms, child: Text("Відправити код"))
      ],
    ));
  }
}
