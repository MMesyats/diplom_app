import 'package:diplom_app/common/FormGenerator.dart';
import 'package:diplom_app/models/Form.dart';
import 'package:diplom_app/models/NoteModel.dart';
import 'package:diplom_app/notes/NoteButton.dart';
import 'package:diplom_app/services/Backend.dart';
import 'package:flutter/material.dart';

class AddNoteDialog extends StatefulWidget {
  final String userId;
  AddNoteDialog({this.userId});

  @override
  _AddNoteDialogState createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  static const _padding =
      EdgeInsets.only(top: 60, left: 15, right: 15, bottom: 50);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: _padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text(
                "Додавання запису",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Text(
                "Виберіть тип запису",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            FutureBuilder<List<FormModel>>(
                future: Backend.getForms(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null)
                    return ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: double.infinity,
                        height: 300,
                        child: ListView.separated(
                            itemBuilder: (context, index) => NoteButton(
                                  title: snapshot.data[index].name,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FormGenerator(
                                                  userId: widget.userId,
                                                  noteModel: NoteModel(
                                                      form: FormModel(
                                                          id: snapshot
                                                              .data[index].id,
                                                          name: snapshot
                                                              .data[index].name,
                                                          schema: snapshot
                                                              .data[index]
                                                              .schema)),
                                                ))).then(
                                        (value) => setState(() {}));
                                  },
                                ),
                            separatorBuilder: (context, index) => Divider(
                                  color: Colors.grey,
                                  height: 1,
                                ),
                            itemCount: snapshot.data.length),
                      ),
                    );
                  return Container(
                    width: double.infinity,
                    height: 300,
                    child: Center(
                      child: Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator()),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
