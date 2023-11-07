import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

class CodeDisplayScreen extends StatefulWidget {
  const CodeDisplayScreen({super.key, this.data});
  final String? data;

  @override
  State<CodeDisplayScreen> createState() => _CodeDisplayScreenState();
}

class _CodeDisplayScreenState extends State<CodeDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('QR Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          displayOutputCode(context),
          const SizedBox(height: 15),
          const Text('Past QR Code to back of degree'),
          const Spacer(),
          const Text(
            'This QR Code contains data hash(sha256) and txHash',
            style: TextStyle(fontSize: 11),
          ),
        ]),
      ),
    );
  }

//

//

//                  E X T R A S

//

//

  BarcodeWidget displayOutputCode(BuildContext context) {
    return BarcodeWidget(
      height: MediaQuery.of(context).size.width <=
              MediaQuery.of(context).size.height
          ? MediaQuery.of(context).size.width - 60 * 2
          : MediaQuery.of(context).size.height - 60 * 3,
      data: widget.data ?? '',
      barcode: Barcode.qrCode(),
      errorBuilder: (context, error) => _onError(error),
    );
  }

  Widget _onError(String message) {
    return Text(
      message.substring(message.indexOf('Barcode, '), message.length - 1),
    );
  }
}
