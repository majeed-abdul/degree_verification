import 'dart:io';
import 'package:degree_verification/screens/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});
  static String id = 'verify_screen';

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isFlashOn = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: <Widget>[
        Container(child: _buildQrView(context)),
        Padding(
          padding: const EdgeInsets.all(55),
          child: MediaQuery.of(context).size.width <
                  MediaQuery.of(context).size.height
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    cameraSwitchButton(),
                    flashButton(),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    flashButton(),
                    cameraSwitchButton(),
                  ],
                ),
        ),
      ],
    );
  }
  //

//

//                  E X T R A S

//

//

  Container cameraSwitchButton() {
    return customButton(
      onPress: () async {
        if (isFlashOn) {
          controller?.toggleFlash();
          isFlashOn = await controller?.getFlashStatus() ?? false;
          setState(() {});
        }
        controller?.flipCamera();
      },
      icon: Icons.flip_camera_ios_outlined,
      color: Colors.white,
    );
  }

  Container flashButton() {
    return customButton(
        onPress: () async {
          controller?.toggleFlash();
          isFlashOn = await controller?.getFlashStatus() ?? false;
          setState(() {});
        },
        icon: isFlashOn
            ? Icons.flashlight_on_outlined
            : Icons.flashlight_off_outlined,
        color: Colors.white);
  }

  Widget _buildQrView(BuildContext context) {
    double scanArea =
        MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
            ? MediaQuery.of(context).size.width / 1.25
            : MediaQuery.of(context).size.height / 1.5;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.greenAccent,
        borderLength: 40,
        borderRadius: 1,
        borderWidth: 9,
        cutOutSize: scanArea,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _onScanComplete(scanData);
    });
  }

  void _onScanComplete(Barcode code) async {
    controller?.pauseCamera();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ResultScreen(result: code),
      ),
    ).then((value) => controller?.resumeCamera());
  }

  Container customButton({
    required void Function() onPress,
    required IconData icon,
    Color color = Colors.black,
  }) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(69),
        border: Border.all(color: color, width: 3),
      ),
      // child: IconButton(
      //   iconSize: 30,
      //   icon: icon,
      //   color: color,
      //   onPressed: onPress,
      // ),
      child: GestureDetector(onTap: onPress, child: Icon(icon, color: color)),
    );
  }
}
