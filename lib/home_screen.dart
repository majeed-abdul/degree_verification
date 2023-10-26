import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:developer';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String id = "home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Client httpClient = Client();
  Web3Client ethClient = Web3Client(
    "https://sepolia.infura.io/v3/e13262dbb2d84336b7b999c45469350c",
    Client(),
  );
  final myAddress = "0x472EbDcBB17076a3724C2bF14F234edD43103820";

  String testSig =
      "b83380f6e1d09411ebf49afd1a95c738686bfb2b0fe2391134f4ae3d6d77b78a6c305afcac930a3ea1721c04d8a1a979016baae011319746323a756fbaee1811";
  //   6c305afcac930a3ea1721c04d8a1a979016baae011319746323a756fbaee1811
  var data1 = 'null-1';
  var data2 = 'null-2';

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
                onPressed: () {
                  // push(myAddress);
                },
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text("Publish to BlockChain"),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  pushn();
                },
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text("Verify Degree"),
                ),
              ),
            ],
          ),
          // const Spacer(),
          // Text(
          //   data1,
          //   style: const TextStyle(fontSize: 16),
          //   textAlign: TextAlign.center,
          // ),
          // const Spacer(),
          // Text(
          //   data2,
          //   style: const TextStyle(fontSize: 16),
          //   textAlign: TextAlign.center,
          // ),
          const Spacer(),
        ],
      ),
    );
  }

  Future<void> push(String targetAddress) async {
    // EthereumAddress addr = EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query("upload", [testSig]);
    inspect(result);
    // data1 = result[0];
    setState(() {});
  }

  Future<void> pushn() async {
    // EthereumAddress addr = EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query("uploadn", []);
    inspect(result);
    data2 = result[0];
    setState(() {});
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
      contract: contract,
      function: ethFunction,
      params: args,
    );
    return result;
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0x1735019B45B04d753Df1334f318200c49b6882a2";
    final contract = DeployedContract(
      ContractAbi.fromJson(abi, "Intuition"),
      EthereumAddress.fromHex(contractAddress),
    );
    return contract;
  }
}
