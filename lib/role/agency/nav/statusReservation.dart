import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart' as globals;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'package:testprojectbc/role/agency/checkReservation/completedPage.dart';
import 'package:testprojectbc/role/agency/checkReservation/listQRScan.dart';
import 'package:testprojectbc/role/agency/checkReservation/qrCodeScanPage.dart';
import 'package:testprojectbc/role/agency/checkReservation/reservationsCK.dart';
import 'package:testprojectbc/role/agency/checkReservation/upComingPage.dart';
import 'package:testprojectbc/role/agency/checkReservation/upcoming2.dart';
import 'package:testprojectbc/role/agency/nav/navHelper.dart';
import 'package:testprojectbc/screen/testBlockchain.dart';
import 'package:testprojectbc/screen/testBlockchainNoDel.dart';

class BookingStatusPage extends StatefulWidget {
  @override
  _BookingStatusPageState createState() => _BookingStatusPageState();
}

class _BookingStatusPageState extends State<BookingStatusPage>
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qrCodeDataProvider = Provider.of<ReservationData>(context);
    print('Currency on Widget: $_Cur -- Total on Widget: $_Total');
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Status'),
        bottom: TabBar(
          labelColor: Colors.black,
          controller: _tabController,
          tabs: [
            Tab(text: 'Upcoming'),
            // Tab(text: 'Reservations'),
            Tab(text: 'Completed'),
            Tab(text: 'QR Decode'),
            // Tab(text: 'Blockchain'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UpComing2Page(),
          // reservationsCKPage(
          //   uidQR: '',
          // ),
          CompletedPage(),
          ListQRPage(),
          // testBCNoDel(),
        ],
      ),
    );
  }
}
