import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteItem extends StatelessWidget {
  NoteItem(
      {Key key, this.title = "", this.date, this.tags = const [], this.onTap})
      : super(key: key);
  final Function onTap;
  final String title;
  final List<String> tags;
  final DateTime date;

  final EdgeInsets _padding = EdgeInsets.all(15);
  final EdgeInsets _margin = EdgeInsets.only(bottom: 15);

  final _radius = BorderRadius.circular(5);
  final _radius2 = BorderRadius.circular(50);

  final _shadow = BoxShadow(
      blurRadius: 6,
      offset: Offset(0, 3),
      color: Colors.black.withOpacity(0.15));

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 160;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: _padding,
        margin: _margin,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: _radius, boxShadow: [_shadow]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: width,
                  child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: tags
                          .map((e) => Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Text(
                                  e.toLowerCase(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: _radius2,
                                    color: Color(0xFF9CBCEC)),
                              ))
                          .toList()),
                ),
                Container(
                  width: 100,
                  child: Text(
                    DateFormat('MM.dd.yyyy')
                        .format(date ?? DateTime(2020, 12, 20)),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
