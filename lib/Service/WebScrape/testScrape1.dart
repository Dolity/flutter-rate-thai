import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(Scrape());

class Scrape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Call Python Method')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // _callPythonMethod();
              _fetchData();
            },
            child: Text('Call Python Method'),
          ),
        ),
      ),
    );
  }

  Future<void> _callPythonMethod() async {
    final url = 'http://127.0.0.1:5000/testG';

    // ข้อมูลที่คุณต้องการส่งไปยัง Python (อาจเป็นข้อมูลอะไรก็ได้)
    // final data = {'key': 'value'};
    // final response = await http.post(
    //   Uri.parse(url),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode(data),
    // );

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      print(decodedResponse['message']); // พิมพ์ข้อความที่ได้จาก Python
    } else {
      print('Failed to call Python method.');
    }
  }

  Future<void> _fetchData() async {
    final url = 'http://192.168.1.9:5000/testG';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      print(decodedResponse); // พิมพ์ข้อมูลที่ได้รับจาก API
    } else {
      print('Failed to fetch data.');
    }
  }
}
