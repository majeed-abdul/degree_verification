import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

Web3Client ethClient = Web3Client(
  "https://sepolia.infura.io/v3/e13262dbb2d84336b7b999c45469350c",
  Client(),
);
var myAddress = "0x472EbDcBB17076a3724C2bF14F234edD43103820";

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
  String contractAddress =
      "0x1735019B45B04d753Df1334f318200c49b6882a2"; // contract address
  final contract = DeployedContract(
    ContractAbi.fromJson(abi, "Intuition"),
    EthereumAddress.fromHex(contractAddress),
  );
  return contract;
}
