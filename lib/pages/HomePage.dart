import 'package:diplom_app/common/AddNoteDialog.dart';
import 'package:diplom_app/common/CommonScaffold.dart';
import 'package:diplom_app/home/NoteList.dart';
import 'package:flutter/material.dart';

import '../models/User.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage({this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: widget.user != null
          ? '${widget.user.name} ${widget.user.surname}'
          : 'Головна',
      body: NoteList(
        user: widget.user,
      ),
      floatingButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => AddNoteDialog(
                    userId: widget.user.id,
                  )).then((value) => setState(() {}));
        },
      ),
    );
  }
}
