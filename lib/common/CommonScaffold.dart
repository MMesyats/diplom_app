import 'package:diplom_app/common/QRDialog.dart';
import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  const CommonScaffold(
      {Widget body, this.floatingButton = null, this.title = ''})
      : _body = body;

  final String title;
  final Widget _body;
  final Widget floatingButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final node = FocusScope.of(context).focusedChild;
        if (node != null) node.unfocus();
      },
      child: Scaffold(
        floatingActionButton: floatingButton,
        backgroundColor: const Color(0xFFe7edf3),
        appBar: AppBar(
          centerTitle: true,
          title: Text(title),
          leading: IconButton(
            onPressed: () {},
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
            children: [],
          ),
        ),
        body: GestureDetector(child: _body),
      ),
    );
  }
}
