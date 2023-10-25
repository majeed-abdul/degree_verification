import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HttpClient httpClient;
  late Web3Client web3client;
  final myAddress = "0x472EbDcBB17076a3724C2bF14F234edD43103820";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // backgroundColor: Colors.blue,
          title: const Text("Degree Verification")),
    );
  }
}
