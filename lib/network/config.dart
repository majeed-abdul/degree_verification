import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:hex/hex.dart';

var myAddress =
    '9b1973a1ea2916317aed13b9575d8461125341956048c458bdcf78f9b04735f2';

final Client httpClient = Client();
final Web3Client ethClient = Web3Client(
  "https://sepolia.infura.io/v3/8fb9776787ea4283a449ca99699b5cad",
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
    chainId: null,
    fetchChainIdFromNetworkId: true,
  );
  debugPrint('== Tx-Hash: $result');
  return result;
}

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = '0x8a2B53599c98333989F8b9e8bF88DA4971e12C5D';
  final contract = DeployedContract(
    ContractAbi.fromJson(abi, 'Institution'),
    EthereumAddress.fromHex(contractAddress),
  );
  return contract;
}

Future<List<String>> getEventsFromTxHash(String txHash) async {
  final transaction = await ethClient.getTransactionByHash(txHash);
  if (transaction == null) {
    throw 'transaction not found';
  }
  DeployedContract contract = await loadContract();
  final event = contract.event('push');
  final filter = FilterOptions.events(
    event: event,
    contract: contract,
    fromBlock: BlockNum.exact(transaction.blockNumber.blockNum),
    toBlock: BlockNum.exact(transaction.blockNumber.blockNum),
  );
  final events = await ethClient.getLogs(filter);
  if (events.length == 1) {
    // debugPrint(' ===== Event in HEX: "${events[0]}"');

    var hexData = '${events[0].data}';
    if (hexData.startsWith('0x')) {
      hexData = hexData.substring(2);
    }
    List<int> bytes = HEX.decode(hexData);
    String decodedString = String.fromCharCodes(bytes);
    final String sig = decodedString.substring(96, 96 + 142);
    final String dataHash = decodedString.substring(288, 288 + 64);

    debugPrint('\n= EventTopic: ${events[0].topics?[0]!.substring(2, null)}');
    debugPrint(
        '== Signature: ${sig.substring(0, 55)}...${sig.substring(sig.length - 5)}');
    debugPrint('== Data Hash: $dataHash\n');
    return [dataHash, sig];
  } else {
    throw 'unknown transaction found';
  }
}
