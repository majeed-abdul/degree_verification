import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // HttpClient httpClient = Client();
  Web3Client web3client = Web3Client(
    "https://sepolia.infura.io/v3/e13262dbb2d84336b7b999c45469350c",
    Client(),
  );
  final myAddress = "0x472EbDcBB17076a3724C2bF14F234edD43103820";

  String testSig =
      "b83380f6e1d09411ebf49afd1a95c738686bfb2b0fe2391134f4ae3d6d77b78a6c305afcac930a3ea1721c04d8a1a979016baae011319746323a756fbaee1811";
  //   6c305afcac930a3ea1721c04d8a1a979016baae011319746323a756fbaee1811

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // backgroundColor: Colors.blue,
          title: const Text("Degree Verification")),
      body: Column(
        children: [
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text("PUSH"),
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Future<void> push(String targetAddress) async {
    EthereumAddress addr = EthereumAddress.fromHex(targetAddress);
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final 
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets.abi.json");
    String contractAddress = "0x30A31D0c61CB8C849F1A5eDe3905004739Cb6ccB";
    final contract = DeployedContract(
      ContractAbi.fromJson(abi, "Intuition"),
      EthereumAddress.fromHex(contractAddress),
    );
    return contract;
  }
}
