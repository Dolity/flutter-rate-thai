import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:testprojectbc/Service/provider/reservationBlockchian.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:convert/convert.dart';
import 'package:web_socket_channel/io.dart';

class NotesServices extends ChangeNotifier {
  List<Note> notes = [];

  final String _rpcUrl =
      'https://sepolia.infura.io/v3/868de39ad9c640cc987dd0b7a0174b49';
  final String _wsUrl =
      'wss://sepolia.infura.io/ws/v3/868de39ad9c640cc987dd0b7a0174b49';
  bool isLoading = true;
  final myAddress = '0x8936539b50667A6Be0ee5bCA2a0F1E9093FD30cf';
  final String _privatekey =
      '0x8c35bda0169b6cb23e770af128aeb0fc3caeefb3301a05fe557e50a26d64f19c'; //0x49ad2885e86e1b38f7dc1eee80e54f17ab826713b8aed9087b0a559b579ebf05

  late Web3Client _web3cient;

  NotesServices() {
    init();
  }

  Future<void> init() async {
    var httpClient = Client();
    _web3cient = Web3Client(
        "https://sepolia.infura.io/v3/868de39ad9c640cc987dd0b7a0174b49",
        httpClient);
    await getABI();
    await getCredentials();
    await getDeployedContract();
  }

  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;

  Future<void> getABI() async {
    String abiFile =
        await rootBundle.loadString('contractsBC/NotesContract.json');
    String contractAddress =
        "0x1e2D7e1706fC7630bD5E583FFF6DA78E023Fc235"; //Smart Contract Address (Deployed) 0x778F9c5d9191e02f7E83C05140dF8449cD1d3C12 / 0x1e2D7e1706fC7630bD5E583FFF6DA78E023Fc235

    _abiCode = ContractAbi.fromJson(abiFile, "NotesContract");
    _contractAddress = EthereumAddress.fromHex(contractAddress);

    print('Decode ABI: $_contractAddress');
  }

  late EthPrivateKey _creds;
  late EthereumAddress _ownAddress;
  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privatekey);
    _ownAddress = await _creds.address;
    print('key: $_privatekey');
    print('_creds: $_creds');
    print('_ownAddress: $_ownAddress');
  }

  late DeployedContract _deployedContract;
  late ContractFunction _createNote;
  late ContractFunction _deleteNote;
  late ContractFunction _notes;
  late ContractFunction _noteCount;

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _createNote = _deployedContract.function('createNote');
    _deleteNote = _deployedContract.function('deleteNote');
    _notes = _deployedContract.function('notes');
    _noteCount = _deployedContract.function('noteCount');
    await fetchNotes();
  }

  Future<void> fetchNotes() async {
    List totalTaskList = await _web3cient.call(
      contract: _deployedContract,
      function: _noteCount,
      params: [],
    );

    int totalTaskLen = totalTaskList[0].toInt();
    notes.clear();
    if (totalTaskLen > 0) {
      for (var i = 0; i < totalTaskLen; i++) {
        var temp = await _web3cient.call(
            contract: _deployedContract,
            function: _notes,
            params: [BigInt.from(i)]);
        if (temp.isNotEmpty && temp[1] != "") {
          notes.add(
            Note(
              id: (temp[0] as BigInt).toInt(),
              agencyBC: temp[1],
              currencyBC: temp[2],
              rateBC: temp[3],
              amountBC: temp[4],
              totalBC: temp[5],
              dateBC: temp[6],
              firstnameBC: temp[7],
              lastnameBC: temp[8],
              genderBC: temp[9],
            ),
          );
        }
        print("temp: $temp");
      }
    }
    isLoading = false;

    notifyListeners();
  }

  Future<void> addNote(
      String agencyBC,
      String currencyBC,
      String rateBC,
      String amountBC,
      String totalBC,
      String dateBC,
      String firstnameBC,
      String lastnameBC,
      String genderBC) async {
    // BigInt cId = await _web3cient.getChainId();
    await _web3cient.sendTransaction(
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _createNote,
        parameters: [
          agencyBC,
          currencyBC,
          rateBC,
          amountBC,
          totalBC,
          dateBC,
          firstnameBC,
          lastnameBC,
          genderBC
        ],
      ),
      chainId: 11155111,
    );
    isLoading = true;
    fetchNotes();
  }

  Future<void> deleteNote(int id) async {
    await _web3cient.sendTransaction(
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _deleteNote,
        parameters: [BigInt.from(id)],
      ),
      chainId: 11155111,
    );
    isLoading = true;
    notifyListeners();
    fetchNotes();
  }
}
