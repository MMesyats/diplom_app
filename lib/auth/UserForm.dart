import 'package:diplom_app/models/AuthModel.dart';
import 'package:diplom_app/models/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  UserForm({Key key}) : super(key: key);

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _cityController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _specializationController = TextEditingController();

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  static const _bloodTypes = [
    '0(I)+',
    'A(II)+',
    'B(III)+',
    'AB(IV)+',
    '0(I)-',
    'A(II)-',
    'B(III)-',
    'AB(IV)-',
  ];

  String _bloodType = _bloodTypes[0];
  bool isDoctor = false;

  DateTime selectedDate = DateTime.now();
  _selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  _sendData() async {
    final authModel = Provider.of<AuthModel>(context, listen: false);
    await authModel.writeUser(User(
      name: widget._nameController.text,
      surname: widget._surnameController.text,
      lastname: widget._lastnameController.text,
      city: widget._cityController.text,
      birthdayDate: selectedDate,
      bloodType: _bloodType,
      height: num.parse(widget._heightController.text),
      weight: num.parse(widget._weightController.text),
    ));
    Navigator.of(context)
      ..pop()
      ..pushNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(hintText: "Імя"),
              controller: widget._nameController,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "Фамілія"),
              controller: widget._surnameController,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "По-батькові"),
              controller: widget._lastnameController,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "Місто"),
              controller: widget._cityController,
            ),
            TextButton(
                onPressed: _selectDate, child: Text("Обрати дату народження")),
            TextFormField(
              decoration: InputDecoration(hintText: "Зріст, см"),
              controller: widget._heightController,
              validator: (val) {
                try {
                  num.parse(val);
                  return null;
                } catch (e) {
                  return "Не число";
                }
              },
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "Вага, кг"),
              controller: widget._weightController,
            ),
            DropdownButton(
                value: _bloodType,
                onChanged: (val) {
                  setState(() {
                    _bloodType = val;
                  });
                },
                items: _bloodTypes
                    .map(
                      (e) => DropdownMenuItem(value: e, child: Text(e)),
                    )
                    .toList()),
            CheckboxListTile(
              value: isDoctor,
              onChanged: (val) {
                setState(() {
                  isDoctor = val;
                });
              },
              title: Text("Я лікар"),
            ),
            if (isDoctor)
              TextFormField(
                decoration: InputDecoration(hintText: "СпеціалізаціяВ"),
                controller: widget._specializationController,
              ),
            TextButton(onPressed: _sendData, child: Text("Зарееструватся"))
          ],
        ));
  }
}
