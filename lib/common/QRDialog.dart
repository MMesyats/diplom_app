import 'package:diplom_app/services/Backend.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRDialog extends StatelessWidget {
  const QRDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
            height: 300,
            width: 300,
            child: FutureBuilder(
              builder: (conext, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Center(
                    child: QrImage(
                      data: snapshot.data,
                      size: 2000,
                    ),
                  );
                }
                return Center(
                  child: Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator()),
                );
              },
              future: Backend.getPermissionToken(),
            )));
  }
}
