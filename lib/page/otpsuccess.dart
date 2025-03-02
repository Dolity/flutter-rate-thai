import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtpSuccessPage extends StatefulWidget {
  String? get title => null;

  @override
  State<StatefulWidget> createState() {
    return _OtpSuccessPage();
  }
}

class _OtpSuccessPage extends State<OtpSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Email W OTP PASS!',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
