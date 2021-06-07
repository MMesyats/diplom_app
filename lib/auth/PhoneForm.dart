import 'package:diplom_app/auth/SmsForm.dart';
import 'package:diplom_app/models/AuthModel.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneForm extends StatefulWidget {
  PhoneForm({Key key}) : super(key: key);
  final _phoneController = TextEditingController();

  @override
  _PhoneFormState createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
  _sendSms() {
    final authModel = Provider.of<AuthModel>(context, listen: false);
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget._phoneController.text,
        verificationCompleted: (credential) {},
        verificationFailed: (err) {
          print(err);
        },
        codeSent: (String verificationId, int resendToken) {
          authModel.verificationId = verificationId;
          authModel.currentForm = SmsForm();
        },
        codeAutoRetrievalTimeout: (_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          decoration: InputDecoration(hintText: "+38 (099) 999 99 99"),
          controller: widget._phoneController,
          inputFormatters: [TextInputMask(mask: '\\+38 (999) 999 99 99')],
        ),
        TextButton(onPressed: _sendSms, child: Text("Відправити СМС"))
      ],
    ));
  }
}
