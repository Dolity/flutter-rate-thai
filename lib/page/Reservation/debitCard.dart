import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testprojectbc/page/Reservation/genQR.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:async';

class PayDebitCardPage extends StatefulWidget {
  @override
  _PayDebitCardPage createState() => _PayDebitCardPage();
}

class _PayDebitCardPage extends State<PayDebitCardPage>
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Debit Card'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter Debit Card Details'),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Card Number'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Expiration Date'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'CVV'),
            ),
            SizedBox(height: 16.0),
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
                  'Next',
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
            Center(
              child: Text(
                'Cancle Reservation: $_remainingTime',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
