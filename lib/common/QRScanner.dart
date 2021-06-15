import 'dart:io';

import 'package:diplom_app/services/Backend.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../home/NoteList.dart';
import '../pages/HomePage.dart';

class QRScanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  static const _borderRadius = const BorderRadius.all(Radius.circular(10));
  static const _textStyle = const TextStyle(
      fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white);
  static const _iconMargin = const EdgeInsets.only(top: 20);
  @override
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _buildQrView(context),
          Positioned(
            top: 45,
            right: 0,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            bottom: 90,
            child: Column(
              children: <Widget>[
                if (result != null)
                  Text(
                    'переход ...',
                    style: _textStyle,
                  )
                else
                  Text(
                    'Наведите камеру на QR код',
                    style: _textStyle,
                  ),
                Container(
                  margin: _iconMargin,
                  child: GestureDetector(
                      onTap: () async {
                        await controller?.toggleFlash();
                        setState(() {});
                      },
                      child: FutureBuilder(
                        future: controller?.getFlashStatus(),
                        builder: (context, snapshot) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: _borderRadius,
                                    color: Colors.white),
                              ),
                              Icon(
                                snapshot.data
                                    ? Icons.flash_off
                                    : Icons.flash_on,
                                color: Colors.black,
                                size: 35,
                              )
                            ],
                          );
                        },
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    const _scanArea = 250.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 40,
          borderWidth: 10,
          cutOutSize: _scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result != null) {
          controller.pauseCamera();
          controller.dispose();
          Backend.givePermissionToken(result.code)
            ..then((user) {
              Navigator.of(context)
                ..pop()
                ..push(MaterialPageRoute(
                    builder: (context) => HomePage(user: user)));
            });
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
