import 'package:diplom_app/home/NoteItem.dart';
import 'package:flutter/material.dart';

class NoteList extends StatefulWidget {
  NoteList({Key key}) : super(key: key);
  final searchInput = TextEditingController();

  @override
  _NoteListState createState() => _NoteListState();
}

class SortModel {
  SortModel(this.label, this.value, this.order);
  String label;
  String value;
  int order;
}

class _NoteListState extends State<NoteList> {
  final _padding = EdgeInsets.all(15);
  final _margin = EdgeInsets.only(bottom: 45);

  final _radius = BorderRadius.circular(5);
  final _shadow = BoxShadow(
      blurRadius: 6,
      offset: Offset(0, 3),
      color: Colors.black.withOpacity(0.15));

  final List<SortModel> items = [
    SortModel("по назві", 'name', 1),
    SortModel("по назві", 'name', -1),
    SortModel("по даті", 'created_at', 1),
    SortModel("по даті", 'created_at', -1),
  ];

  SortModel sortValue;
  List<String> tags = [];

  _changeSort(SortModel val) {
    setState(() {
      sortValue = val;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  _submitTags(String value) {
    setState(() {
      tags = value.trim().split(" ");
    });
    print(tags);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 35;
    return ListView(
      children: [
        Container(
          padding: _padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: _margin,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width * 0.6,
                      padding: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: _radius,
                          boxShadow: [_shadow]),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.6 - 65,
                            child: TextField(
                              controller: widget.searchInput,
                              decoration: InputDecoration(
                                  hintText: "Пошук", border: InputBorder.none),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.search,
                                size: 20,
                              ),
                              onPressed: () {
                                _submitTags(widget.searchInput.text);
                              })
                        ],
                      ),
                    ),
                    Container(
                      width: width * 0.4,
                      padding: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: _radius,
                          boxShadow: [_shadow]),
                      child: DropdownButton(
                          hint: Text("Сортувати"),
                          value: sortValue,
                          onChanged: _changeSort,
                          isExpanded: true,
                          underline: Container(),
                          items: items
                              .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Row(
                                    children: [
                                      Text(e.label),
                                      Icon(
                                        e.order == 1
                                            ? (Icons.arrow_upward)
                                            : (Icons.arrow_downward),
                                        size: 15,
                                      )
                                    ],
                                  )))
                              .toList()),
                    )
                  ],
                ),
              ),
              NoteItem(
                title: "test",
                tags: [
                  'test',
                  'testtestset',
                  'testsetst',
                  'test1231',
                  'test',
                  'test'
                ],
              ),
              NoteItem(
                title: "test",
                tags: [
                  'test',
                  'testtestset',
                  'testsetst',
                  'test1231',
                  'test',
                  'test'
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
