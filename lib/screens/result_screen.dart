import 'package:degree_verification/components/custom_ui.dart';
import 'package:degree_verification/network/config.dart';
import 'package:degree_verification/network/keys.dart';
import 'package:ecdsa/ecdsa.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.result});
  final String result;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  ScrollController scrollCon = ScrollController();
  String dataHash = '';
  String signature = '';
  String qRdataHash = '';
  String txHash = '';
  bool signatuerVerified = false;
  bool spinning = true;
  @override
  void initState() {
    setStrings();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.qr_code_scanner_outlined, size: 30),
      ),
      body: Spinner(
        spinning: spinning,
        child: SafeArea(
          child: SingleChildScrollView(
            controller: scrollCon,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Verifacation',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  resultText(),
                  const SizedBox(height: 20),
                  const Text(
                    'Result:',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Data : ${dataHash == qRdataHash ? 'Verified' : 'Invalid'}',
                    style: const TextStyle(fontSize: 19),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Signature : ${signatuerVerified ? 'Verified' : 'Invalid'}',
                    style: const TextStyle(fontSize: 19),
                  ),
                  const SizedBox(height: 55),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//

//

//                  E X T R A S

//

//

  Container resultText() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      child: Column(
        children: [
          const Text(
            'QR Result',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SelectableText(
            widget.result,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  void getData() async {
    try {
      qRdataHash = widget.result.substring(67, null);
      txHash = widget.result.substring(0, 66);
      debugPrint('= QR DataHash = $qRdataHash');
      debugPrint('= QR Tx  Hash = $txHash');
      List<String> l = await getEventsFromTxHash(txHash);
      dataHash = l[0];
      signature = l[1];
      var hash = List<int>.generate(qRdataHash.length ~/ 2, (i) {
        return int.parse(
          qRdataHash.substring(i * 2, i * 2 + 2),
          radix: 16,
        );
      });
      signatuerVerified = verify(
        pubKey,
        hash,
        Signature.fromASN1Hex(signature),
      );
    } catch (e) {
      debugPrint('= Error Occured');
    }
    setState(() {
      spinning = false;
    });
  }

  void setStrings() {
    try {
      qRdataHash = widget.result.substring(67, null);
      txHash = widget.result.substring(0, 66);
      debugPrint('= QR DataHash = $qRdataHash');
      debugPrint('= QR Tx  Hash = $txHash');
    } catch (e) {
      showSnackBar(context, 'invalid QR scanned');
      Navigator.pop(context);
    }
  }
}
