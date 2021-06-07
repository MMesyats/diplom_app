import 'package:diplom_app/models/Form.dart';
import 'package:diplom_app/services/Backend.dart';
import 'package:flutter/material.dart';

class AddNoteDialog extends StatelessWidget {
  const AddNoteDialog({Key key}) : super(key: key);
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
                    return Container(
                      width: double.infinity,
                      height: 300,
                      child: ListView(
                          children: snapshot.data
                              .map((e) => Container(
                                    child: Text(e.name),
                                  ))
                              .toList()),
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
