import 'package:diplom_app/common/QRDialog.dart';
import 'package:diplom_app/models/User.dart';
import 'package:diplom_app/services/Backend.dart';
import 'package:flutter/material.dart';

class CommonScaffold extends StatefulWidget {
  CommonScaffold({Widget body, this.floatingButton = null, this.title = ''})
      : _body = body;

  final String title;
  final Widget _body;
  final Widget floatingButton;

  @override
  _CommonScaffoldState createState() => _CommonScaffoldState();
}

class _CommonScaffoldState extends State<CommonScaffold> {
  @override
  void initState() {
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final node = FocusScope.of(context).focusedChild;
        if (node != null) node.unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: widget.floatingButton,
        backgroundColor: const Color(0xFFe7edf3),
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
            icon: Icon(Icons.menu),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.qr_code),
                onPressed: () {
                  showDialog(context: context, builder: (_) => QRDialog());
                })
          ],
        ),
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: Text('Главная'),
                onTap: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
              FutureBuilder<User>(
                  future: Backend.getUserInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      if (snapshot.data.isDoctor != null) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text('Пациенты'),
                              onTap: () {
                                Navigator.pushNamed(context, '/patients');
                              },
                            ),
                            ListTile(
                              title: Text('Доктора'),
                              onTap: () {
                                Navigator.pushNamed(context, '/doctors');
                              },
                            ),
                            ListTile(
                              title: Text('Отсканировать'),
                              onTap: () {
                                Navigator.pushNamed(context, '/qrscanner');
                              },
                            ),
                          ],
                        );
                      } else {
                        return ListTile(
                          title: Text('Доктора'),
                          onTap: () {
                            Navigator.pushNamed(context, '/doctors');
                          },
                        );
                      }
                    }
                    return SizedBox();
                  }),
            ],
          ),
        ),
        body: GestureDetector(child: widget._body),
      ),
    );
  }
}
