import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:web3dart/web3dart.dart';

class GetBalancePage extends StatefulWidget {
  const GetBalancePage({super.key});

  @override
  State<GetBalancePage> createState() => GetBalanceState();
}

class GetBalanceState extends State<GetBalancePage> {
  late Client httpClient;
  late Web3Client ethClient;
  final myAddress = "0x8936539b50667A6Be0ee5bCA2a0F1E9093FD30cf";
  double _value = 0.0;
  int myAmount = 0;
  var myData;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
        "https://sepolia.infura.io/v3/868de39ad9c640cc987dd0b7a0174b49",
        httpClient);
    getBalance(myAddress);
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString('build/contracts/abi.json');
    String contractAddress = "0xA81f1383CF5725609F25e7a0693ffbb9Fa23F8D9";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "XCoin"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<void> getBalance(String targetAddress) async {
    List<dynamic> result = await query("getBalance", []);
    myData = result[0];
    print(myData);
    setState(() {});
  }

  Future<String> withdrawCoin() async {
    var bigAmount = BigInt.from(myAmount);
    var response = await submit("withdrawBalance", [bigAmount]);
    print(bigAmount);
    return response;
  }

  Future<String> depositCoin() async {
    var bigAmount = BigInt.from(myAmount);
    var response = await submit("depositBalance", [bigAmount]);
    print(bigAmount);
    return response;
  }

  Future<String> submit(String function, List<dynamic> args) async {
    EthPrivateKey credential = EthPrivateKey.fromHex(
        "8c35bda0169b6cb23e770af128aeb0fc3caeefb3301a05fe557e50a26d64f19c");
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(function);
    final result = await ethClient.sendTransaction(
        credential,
        Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: args,
          maxGas: 1000000,
        ),
        chainId: 11155111);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 50),
            margin: EdgeInsets.all(10),
            child: Text(
              "${myData} \XCoin",
              style: TextStyle(fontSize: 40),
            ),
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(top: 50),
              height: 40,
              width: 200,
              color: Colors.greenAccent,
              child: Center(
                child: Text("REFRESH", style: TextStyle(fontSize: 20)),
              ),
            ),
            onTap: () {
              getBalance(myAddress);
            },
          ),
          Divider(
            height: 50,
          ),
          SfSlider(
              min: 0.0,
              max: 10.0,
              value: _value,
              interval: 1,
              showTicks: true,
              showLabels: true,
              enableTooltip: true,
              minorTicksPerInterval: 1,
              onChanged: (dynamic value) {
                setState(() {
                  _value = value;
                  myAmount = _value.round();
                });
              }),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(top: 50),
              height: 40,
              width: 200,
              color: Colors.blueAccent,
              child: Center(
                child: Text("DEPOSIT", style: TextStyle(fontSize: 20)),
              ),
            ),
            onTap: () {
              depositCoin();
            },
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(top: 50),
              height: 40,
              width: 200,
              color: Colors.pinkAccent,
              child: Center(
                child: Text("WITHDRAW", style: TextStyle(fontSize: 20)),
              ),
            ),
            onTap: () {
              withdrawCoin();
            },
          ),
          Container(
              padding: EdgeInsets.only(top: 150),
              child: Center(
                child: Text(
                  "This is a basic UI",
                  style: TextStyle(fontSize: 30, color: Colors.grey),
                ),
              ))
        ],
      )),
    );
  }
}
