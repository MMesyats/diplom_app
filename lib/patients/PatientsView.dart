import 'package:diplom_app/pages/HomePage.dart';
import 'package:flutter/material.dart';

import '../common/CommonScaffold.dart';
import '../home/NoteItem.dart';
import '../models/User.dart';
import '../services/Backend.dart';

class PatientsView extends StatelessWidget {
  final String title;
  PatientsView() : title = 'Пациенты';
  PatientsView.doctors() : title = 'Доктора';
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: title,
      body: FutureBuilder<List<User>>(
          future: title == 'Пациенты'
              ? Backend.getPatients()
              : Backend.getDoctors(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null)
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return NoteItem(
                      date: snapshot.data[index].birthdayDate,
                      title:
                          '${snapshot.data[index].name} ${snapshot.data[index].surname}',
                      onTap: () {
                        if (title == 'Пациенты') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        user: snapshot.data[index],
                                      )));
                        }
                      },
                    );
                  });
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
