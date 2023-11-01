import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

var myAddress =
    "0xb784dfdd34b87e31ee40025413e6d1798fa200c304f25c0ae4b64a6930664fa3";

Client httpClient = Client();
Web3Client ethClient = Web3Client(
  "https://sepolia.infura.io/v3/e13262dbb2d84336b7b999c45469350c",
  httpClient,
);

Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
  final contract = await loadContract();
  final ethFunction = contract.function(functionName);
  final result = await ethClient.call(
    contract: contract,
    function: ethFunction,
    params: args,
  );
  debugPrint('\narg ${args.toString()}');
  debugPrint('res ${result.toString()}');
  return result;
}

Future<String> submit(String functionName, List<dynamic> args) async {
  EthPrivateKey credential = EthPrivateKey.fromHex(myAddress);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(functionName);
  final result = await ethClient.sendTransaction(
    credential,
    Transaction.callContract(
      from: credential.address,
      contract: contract,
      function: ethFunction,
      parameters: args,
    ),
    // fetchChainIdFromNetworkId: true,
  );
  debugPrint('\narg ${args.toString()}');
  debugPrint('txHAsh ${result.toString()}');
  return result;
}

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString("assets/abi.json");
  String contractAddress = "0x4969b7F1e33D8e8BC4235f2233c0632d63eDe29d";
  final contract = DeployedContract(
    ContractAbi.fromJson(abi, "Ins"),
    EthereumAddress.fromHex(contractAddress),
  );
  return contract;
}
