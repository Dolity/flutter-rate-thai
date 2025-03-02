import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:testprojectbc/Service/global/dataGlobal.dart' as globals;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'package:testprojectbc/role/admin/CheckKYC/checkURL.dart';
import 'package:testprojectbc/role/admin/CheckKYC/completedPage.dart';
import 'package:testprojectbc/role/admin/CheckKYC/upComingPage.dart';

class KYCStatusPage extends StatefulWidget {
  @override
  _KYCStatusPage createState() => _KYCStatusPage();
}

class _KYCStatusPage extends State<KYCStatusPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  QRViewController? _qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  String? _Cur;
  String? _Total;
  String? _fromUID;
  bool checkStatus = false;
  bool keepStatus = false;
  String qrCodeData = '';

  Future<void> fetchUserData() async {
    try {
      final user = globals.globalUID;

      final usersRef = FirebaseFirestore.instance.collection('usersPIN');
      final snapshot = await usersRef.doc(user).get();
      print('UID: $user');

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        _Cur = data['CurrencyNoti'];
        _Total = data['Total'];
        if (snapshot.data()!['ReservationStatus'] == true) {
          keepStatus = true;
          print('true');
        } else {
          keepStatus = false;
          print('false');
        }
      }

      setState(() {
        _Cur = _Cur;
        _Total = _Total;
        keepStatus = keepStatus;
      });

      print('Currency: $_Cur');
      print('Total: $_Total');
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final qrCodeDataProvider = Provider.of<ReservationData>(context);
    print('Currency on Widget: $_Cur -- Total on Widget: $_Total');
    return Scaffold(
      appBar: AppBar(
        title: Text('KYC Status'),
        bottom: TabBar(
          labelColor: Colors.black,
          controller: _tabController,
          tabs: [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Check URL'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UpComingAdminPage(),
          CompletedAdminPage(),
          CheckURLPage(),
        ],
      ),
    );
  }
}
