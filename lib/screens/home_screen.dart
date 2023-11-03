import 'package:degree_verification/network/keys.dart';
import 'package:degree_verification/screens/get_event_screen.dart';
import 'package:degree_verification/screens/publish_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String id = "home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Degree Verification"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 4),
            const Row(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, PublishScreen.id);
              },
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Text("Push to BlockChain"),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Navigator.pushNamed(context, VerifyScreen.id);
                Navigator.pushNamed(context, GetEventScreen.id);
              },
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Text("Get events from txHash"),
              ),
            ),
            const Spacer(),
            Column(
              children: [
                const Text(
                  "Public Key :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SelectableText(pubKey.toString()),
              ],
            ),
            const Spacer(flex: 5),
          ],
        ),
      ),
    );
  }
}
