import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'package:testprojectbc/page/Reservation/genQR.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:async';

class PayQRCodePage extends StatefulWidget {
  _PayQRCodePageState createState() => _PayQRCodePageState();
}

class _PayQRCodePageState extends State<PayQRCodePage>
    with TickerProviderStateMixin {
  int _countdownDuration = 60;
  int _remainingTime = 60;
  AnimationController? _animationController;
  Animation<double>? _animation;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdownTimer();
    _startCountdownAnimation();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdownAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _countdownDuration),
    );

    _animation = Tween<double>(begin: 1, end: 0).animate(_animationController!)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pop(context); // Go back to the previous page
        }
      });

    _animationController!.forward();
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = _countdownDuration - timer.tick;
      });

      if (timer.tick >= _countdownDuration) {
        timer.cancel();
        // Navigator.pop(context); // Go back to the previous page
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String rate =
        context.watch<ReservationData>().resevaProviRateUpdate.toString();
    String amount = context.watch<ReservationData>().resevaAmount.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                const Text(
                  'QR Code',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/qrDLT.jpg?alt=media&token=9a963538-348c-4510-bf5d-8b6499a89373&_gl=1*joek9b*_ga*MTc1MTk3OTY5MC4xNjc2OTY0MDg2*_ga_CW55HF8NVT*MTY4NjA0MTIxMy42Ni4xLjE2ODYwNDMwODguMC4wLjA.',
                  width: 250,
                  height: 250,
                ),
                const SizedBox(height: 10),
                Text(
                  'Pay: ${double.parse(rate) * double.parse(amount)} THB',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButtonTheme(
            data: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                primary: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRCodePage(
                      user: '',
                    ),
                  ),
                );
              },
              child: Text(
                'Scan QR Code',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: LoadingAnimationWidget.prograssiveDots(
              color: Colors.blue.shade300,
              size: 100,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Cancle Reservation: $_remainingTime',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
