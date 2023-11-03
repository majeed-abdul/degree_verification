import 'package:degree_verification/components/custom_ui.dart';
import 'package:degree_verification/network/config.dart';
import 'package:flutter/material.dart';

class GetEventScreen extends StatefulWidget {
  const GetEventScreen({super.key});
  static String id = 'get_event_screen';

  @override
  State<GetEventScreen> createState() => _GetEventScreenState();
}

class _GetEventScreenState extends State<GetEventScreen> {
  TextEditingController conTxHash = TextEditingController();
  String data = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Get Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            entryBar(
              text: 'Tx Hash',
              child: TextFormField(
                decoration: kDecoration.copyWith(hintText: 'txHash'),
                controller: conTxHash,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Text('Get'),
              ),
              onPressed: () {
                getEventsFromTxHash(conTxHash.text);
              },
            ),
            const SizedBox(height: 20),
            Text(data),
          ],
        ),
      ),
    );
  }
}
