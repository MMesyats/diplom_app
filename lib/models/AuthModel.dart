import 'dart:convert';

import 'package:diplom_app/auth/PhoneForm.dart';
import 'package:diplom_app/models/User.dart';
import 'package:diplom_app/services/Backend.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthModel extends ChangeNotifier {
  String _verificationId;
  Widget _currentForm = PhoneForm();

  get currentForm => _currentForm;
  set currentForm(Widget widget) {
    _currentForm = widget;
    notifyListeners();
  }

  get verificationId => _verificationId;
  set verificationId(String verificationId) =>
      this._verificationId = verificationId;

  Future<void> writeUser(User user) async {
    final userData = await Backend.createUser(user);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('userData', jsonEncode(userData.toJson()));
  }
}
