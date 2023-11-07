import 'dart:convert';

import 'package:crypto/crypto.dart';
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
  String txDataHash = '';
  String signature = '';
  String qRdataHash = '';
  String txHash = '';
  String actualDataHash = '';
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
                    // textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Data : ${txDataHash == qRdataHash ? 'Verified ✔️' : 'Invalid ❌'}',
                    style: const TextStyle(fontSize: 19),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Signature : ${signatuerVerified ? 'Verified ✔️' : 'Invalid ❌'}',
                    style: const TextStyle(fontSize: 19),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Degree data: ${actualDataHash != '' ? txDataHash == actualDataHash ? 'Verified ✔️' : 'Invalid ❌' : 'tap button below'}',
                    style: const TextStyle(fontSize: 19),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        popUpVerify(context);
                      },
                      child: const Text('Verify actual data')),
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
      txDataHash = l[0];
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

  Future<dynamic> popUpVerify(BuildContext context) {
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerFName = TextEditingController();
    TextEditingController controllerDOB = TextEditingController();
    TextEditingController controllerCourse = TextEditingController();
    TextEditingController controllerDegreeNo = TextEditingController();
    TextEditingController controllerRegNo = TextEditingController();
    TextEditingController controllerInstute = TextEditingController();
    TextEditingController controllerCnic = TextEditingController();
    TextEditingController controllerIssueDate = TextEditingController();
    TextEditingController controllerObtainedCgpa = TextEditingController();
    TextEditingController controllerTotalCgpa = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: const Text(
          'Enter Degree data',
          textAlign: TextAlign.center,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        titlePadding: const EdgeInsets.only(top: 15),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              entryData(
                text: 'Name',
                child: TextFormField(
                  decoration: kDecoration.copyWith(hintText: 'Enter Name'),
                  controller: controllerName,
                ),
              ),
              entryData(
                text: 'Father\'s Name',
                child: TextFormField(
                  decoration:
                      kDecoration.copyWith(hintText: "Enter Father's Name"),
                  controller: controllerFName,
                ),
              ),
              entryData(
                text: 'Date of Birth',
                child: TextFormField(
                  decoration: kDecoration.copyWith(
                      hintText: 'Use this format "30-01-2023"'),
                  controller: controllerDOB,
                ),
              ),
              entryData(
                text: 'Course',
                child: TextFormField(
                  decoration:
                      kDecoration.copyWith(hintText: 'Enter envolved Course'),
                  controller: controllerCourse,
                ),
              ),
              entryData(
                text: 'Degree Number',
                child: TextFormField(
                  decoration: kDecoration.copyWith(
                      hintText: 'Enter Degree Seral Number'),
                  controller: controllerDegreeNo,
                ),
              ),
              entryData(
                text: 'Regestration Number',
                child: TextFormField(
                  decoration:
                      kDecoration.copyWith(hintText: 'Enter student reg.No'),
                  controller: controllerRegNo,
                ),
              ),
              entryData(
                text: 'Instuition',
                child: TextFormField(
                  decoration:
                      kDecoration.copyWith(hintText: 'Enter University Name'),
                  controller: controllerInstute,
                ),
              ),
              entryData(
                text: 'CNIC',
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: kDecoration.copyWith(
                      hintText: '13 digit national ID card number'),
                  controller: controllerCnic,
                ),
              ),
              entryData(
                text: 'Issue Date',
                child: TextFormField(
                  decoration: kDecoration.copyWith(
                      hintText: 'Use this format "30-01-2023"'),
                  controller: controllerIssueDate,
                ),
              ),
              entryData(
                text: 'Obtained CGPA',
                child: TextFormField(
                  decoration:
                      kDecoration.copyWith(hintText: 'Use this format "3.00"'),
                  controller: controllerObtainedCgpa,
                ),
              ),
              entryData(
                text: 'Total CGPA',
                child: TextFormField(
                  decoration:
                      kDecoration.copyWith(hintText: 'Use this format "4.00"'),
                  controller: controllerTotalCgpa,
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String finalText =
                        '${controllerName.text.toUpperCase().trim()},${controllerFName.text.toUpperCase().trim()},${controllerDOB.text.trim()},${controllerCourse.text.toUpperCase().trim()},${controllerDegreeNo.text.toUpperCase().trim()},${controllerRegNo.text.toUpperCase().trim()},${controllerInstute.text.toUpperCase().trim()},${controllerCnic.text.trim()},${controllerIssueDate.text.trim()},${controllerObtainedCgpa.text.trim()},${controllerTotalCgpa.text.trim()}';
                    var bytes = utf8.encode(finalText);
                    actualDataHash = sha256.convert(bytes).toString();
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(11),
                    child: Text('Verify'),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
