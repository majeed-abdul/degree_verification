import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.result});
  final Barcode result;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  ScrollController scrollCon = ScrollController();

  String test =
      'Dear Student Download a research paper having 3 or more impact factors related to software reengineering, write review of said paper and submit it along with downloaded paper on LMS. Review: The need of reengineering is started from 1990s. This happens when users need to shift their data from legacy systems to new systems like web. Reengineering is started from source code of current system and ends with source code of new system. And it can be easily done with translation tools it becomes very complex, when we need to change some design factor s and architecture.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Result'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.qr_code_scanner_outlined, size: 30),
      ),
      body: SingleChildScrollView(
        controller: scrollCon,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Text',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              resultText(),
              const SizedBox(height: 20),
              // buttonsRow(),
              // buttonsLabelRow(),
              // const SizedBox(height: 55),
            ],
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
      child: SelectableText(
        '${widget.result.code}',
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
