import 'package:flutter/material.dart';
import 'package:testprojectbc/models/qrModel.dart';

class ReservationData with ChangeNotifier {
  String resevaFromCur = "";
  String resevaToCur = "";
  String resevaAgency = "";
  String resevaAmount = "";
  String resevaRateMoney = "";
  String resevaAgen_Rate = "";

  String resevaProviRateUpdate = ""; // High Rate!
  String resevaProviAgencyUpdate = "";

  String notifyCur = ""; // set for test notify as set value
  String notifyRate = "";

  bool isReservation = false;

  QRCodeData? _qrCodeData;
  QRCodeData? get qrCodeData => _qrCodeData;

  String getUID = "";
  void setQRCodeData(QRCodeData? qrCodeData) {
    _qrCodeData = qrCodeData;
    notifyListeners();
  }

  notifyChange() {
    notifyListeners();
  }
}
