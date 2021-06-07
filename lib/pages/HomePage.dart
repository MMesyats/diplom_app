import 'package:diplom_app/common/AddNoteDialog.dart';
import 'package:diplom_app/common/CommonScaffold.dart';
import 'package:diplom_app/home/NoteList.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "Головна",
      body: NoteList(),
      floatingButton: Ink(
        height: 55,
        width: 55,
        decoration: const ShapeDecoration(
          color: Colors.lightBlue,
          shape: CircleBorder(),
        ),
        child: IconButton(
          onPressed: () {
            showDialog(context: context, builder: (_) => AddNoteDialog());
          },
          icon: Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
