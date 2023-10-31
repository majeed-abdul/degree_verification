import 'package:degree_verification/network/keys.dart';
import 'package:ecdsa/ecdsa.dart';
import 'package:flutter/material.dart';
import 'package:degree_verification/network/config.dart';
import 'package:degree_verification/components/custom_ui.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:developer';

class PublishScreen extends StatefulWidget {
  const PublishScreen({super.key});
  static String id = "publish_screen";

  @override
  State<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
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
  bool _spinning = false;
  late String finalText;
  late String dataHash;
  late bool verified;
  late String sig;
  @override
  Widget build(BuildContext context) {
    return Spinner(
      spinning: _spinning,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.keyboard_backspace),
          ),
          centerTitle: true,
          title: const Text("Enter Degree Details"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                entryBar(
                  text: 'Name',
                  child: TextFormField(
                    decoration: kDecoration.copyWith(hintText: 'Enter Name'),
                    controller: controllerName,
                  ),
                ),
                entryBar(
                  text: 'Father\'s Name',
                  child: TextFormField(
                    decoration:
                        kDecoration.copyWith(hintText: "Enter Father's Name"),
                    controller: controllerFName,
                  ),
                ),
                entryBar(
                  text: 'Date of Birth',
                  child: TextFormField(
                    decoration: kDecoration.copyWith(
                        hintText: 'Use this format "30-01-2023"'),
                    controller: controllerDOB,
                  ),
                ),
                entryBar(
                  text: 'Course',
                  child: TextFormField(
                    decoration:
                        kDecoration.copyWith(hintText: 'Enter envolved Course'),
                    controller: controllerCourse,
                  ),
                ),
                entryBar(
                  text: 'Degree Number',
                  child: TextFormField(
                    decoration: kDecoration.copyWith(
                        hintText: 'Enter Degree Seral Number'),
                    controller: controllerDegreeNo,
                  ),
                ),
                entryBar(
                  text: 'Regestration Number',
                  child: TextFormField(
                    decoration:
                        kDecoration.copyWith(hintText: 'Enter student reg.No'),
                    controller: controllerRegNo,
                  ),
                ),
                entryBar(
                  text: 'Instuition',
                  child: TextFormField(
                    decoration:
                        kDecoration.copyWith(hintText: 'Enter University Name'),
                    controller: controllerInstute,
                  ),
                ),
                entryBar(
                  text: 'CNIC',
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: kDecoration.copyWith(
                        hintText: '13 digit national ID card number'),
                    controller: controllerCnic,
                  ),
                ),
                entryBar(
                  text: 'Issue Date',
                  child: TextFormField(
                    decoration: kDecoration.copyWith(
                        hintText: 'Use this format "30-01-2023"'),
                    controller: controllerIssueDate,
                  ),
                ),
                entryBar(
                  text: 'Obtained CGPA',
                  child: TextFormField(
                    decoration: kDecoration.copyWith(
                        hintText: 'Use this format "3.00"'),
                    controller: controllerObtainedCgpa,
                  ),
                ),
                entryBar(
                  text: 'Total CGPA',
                  child: TextFormField(
                    decoration: kDecoration.copyWith(
                        hintText: 'Use this format "4.00"'),
                    controller: controllerTotalCgpa,
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    finalText =
                        '${controllerName.text.toUpperCase().trim()},${controllerFName.text.toUpperCase().trim()},${controllerDOB.text.trim()},${controllerCourse.text.toUpperCase().trim()},${controllerDegreeNo.text.toUpperCase().trim()},${controllerRegNo.text.toUpperCase().trim()},${controllerInstute.text.toUpperCase().trim()},${controllerCnic.text.trim()},${controllerIssueDate.text.trim()},${controllerObtainedCgpa.text.trim()},${controllerTotalCgpa.text.trim()}';
                    var bytes = utf8.encode(finalText);
                    dataHash = sha256.convert(bytes).toString();
                    var hash = List<int>.generate(
                        dataHash.length ~/ 2,
                        (i) => int.parse(dataHash.substring(i * 2, i * 2 + 2),
                            radix: 16));
                    sig = signature(privKey, hash).toString();
                    verified = verify(pubKey, hash, Signature.fromASN1Hex(sig));
                    // debugPrint(sig.toString());
                    popUpDialoge(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text('Submit'),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> push() async {
    setState(() => _spinning = true);
    List<dynamic> result = await query("upload", [sig, dataHash]);
    inspect(result);
    debugPrint('=========${result.toString()}');
    setState(() => _spinning = false);
  }

  Future<dynamic> popUpDialoge(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: const Text(
          'Are you sure you want to push this Data',
          textAlign: TextAlign.center,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        titlePadding: const EdgeInsets.only(top: 15),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Data:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SelectableText(finalText),
            const SizedBox(height: 14),
            const Text(
              'Hash (sha256):',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            SelectableText(dataHash),
            const SizedBox(height: 14),
            const Text(
              'Signature:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            Text(sig),
            const SizedBox(height: 14),
            Text(
              "Verified ($verified)",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  push();
                },
                child: const Padding(
                  padding: EdgeInsets.all(11),
                  child: Text('push'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
