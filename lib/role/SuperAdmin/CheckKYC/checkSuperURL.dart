import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CheckSuperURLPage extends StatefulWidget {
  @override
  _CheckSuperURLPageState createState() => _CheckSuperURLPageState();
}

class _CheckSuperURLPageState extends State<CheckSuperURLPage> {
  List<String> urls = [];
  Map<String, bool> _canAccessURLs = {};
  Map<String, bool> _foundTags = {};

  @override
  void initState() {
    super.initState();
    fetchUrlsFromFirestore();
  }

  //k79exchange
  //siamexchange
  //superrichthailand
  //superrich1965
  //valueplusexchange
  //vasuexchange
  //x-one
  void fetchUrlsFromFirestore() async {
    // ค้นหา URLs จาก Firebase และเก็บไว้ในตัวแปร urls
    try {
      await Firebase.initializeApp();
      final firestoreURL = FirebaseFirestore.instance.collection('keepUID');
      final snapshotURL = await firestoreURL.doc('pin').get();
      if (snapshotURL.exists) {
        setState(() {
          String urlK79 = snapshotURL.get('urlK79');
          String urlSME = snapshotURL.get('urlSME');
          String urlSRG = snapshotURL.get('urlSRG');
          String urlSRO = snapshotURL.get('urlSRO');
          String urlVPC = snapshotURL.get('urlVPC');
          String urlVSU = snapshotURL.get('urlVSU');
          String urlXNE = snapshotURL.get('urlXNE');

          urls = [
            urlK79 ?? '',
            urlSME ?? '',
            urlSRG ?? '',
            urlSRO ?? '',
            urlVPC ?? '',
            urlVSU ?? '',
            urlXNE ?? '',
          ];

          // สร้าง map _canAccessURLs โดยกำหนดค่าเริ่มต้นเป็น false สำหรับทุก URL
          urls.forEach((url) {
            _canAccessURLs[url] = false;
          });
        });
      }
    } catch (e) {
      print('Error fetching URLs from Firestore: $e');
    }
  }

  Future<void> checkURL(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // ดึงเนื้อหา HTML จาก response
        String htmlContent = response.body;

        // ใช้ htmlParser ในการแปลงเนื้อหา HTML เป็น DOM
        htmlDom.Document document = htmlParser.parse(htmlContent);

        // ค้นหา tag ที่ต้องการในเนื้อหา HTML
        bool foundTag = false;
        List<String> tagsToCheck = _getTagsToCheck();
        for (String tag in tagsToCheck) {
          if (document.querySelector(tag) != null) {
            foundTag = true;
            break;
          }
        }

        // ตรวจสอบว่าค้นหาเจอ tag หรือไม่ และอัปเดตค่าใน _canAccessURLs และ _foundTags
        setState(() {
          _canAccessURLs[url] = true;
          _foundTags[url] = foundTag;

          // ถ้าเจอ tag ที่ต้องการในเว็บไซต์นี้ ก็นำข้อมูล URL และ tag ที่เจอไปเก็บใน Firebase
          if (foundTag) {
            // สร้าง List ของ Strings ที่จะเก็บข้อมูล tags ที่เจอ
            List<String> foundTagsList = _getTagsToCheck().where((tag) {
              return document.querySelector(tag) != null;
            }).toList();

            // นำข้อมูล URL และ tags ที่เจอมาเก็บใน Firebase ในรูปแบบ JSON
            addOrUpdateDataToFirestore(url, foundTagsList);
          }
        });
      } else {
        // กรณีไม่สามารถเชื่อมต่อกับเว็บไซต์ได้
        setState(() {
          _canAccessURLs[url] = false;
          _foundTags[url] = false;
        });
      }
    } catch (e) {
      // กรณีเกิดข้อผิดพลาดในการเชื่อมต่อ
      setState(() {
        _canAccessURLs[url] = false;
        _foundTags[url] = false;
      });
    }
  }

  void addOrUpdateDataToFirestore(
      String url, List<String> foundTagsList) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final collectionRef = firestore.collection('keepUID');

      // ค้นหาเอกสารที่มี URL เท่ากับ url ที่ต้องการอัปเดต
      final querySnapshot =
          await collectionRef.where('url', isEqualTo: url).get();

      // ถ้ามีเอกสารที่ตรงกันใน Firestore ให้ทำการอัปเดตข้อมูล
      if (querySnapshot.docs.isNotEmpty) {
        final documentRef = querySnapshot.docs.first.reference;
        documentRef.update({
          'foundTags': foundTagsList,
        });
      } else {
        // ถ้าไม่มีเอกสารที่ตรงกันใน Firestore ให้ทำการเพิ่มข้อมูลใหม่
        collectionRef.add({
          'url': url,
          'foundTags': foundTagsList,
        });
      }
    } catch (e) {
      print('Error adding/updating data in Firestore: $e');
    }
  }

  List<String> _getTagsToCheck() {
    // รายการแท็ก HTML ที่ต้องการตรวจสอบในเว็บไซต์
    return [
      'div.container',
      'div.table.shadow',
      'table.table',
      'class.table',
      'table.rateTable',
      'div.tablecurrency',
      'div.rate_table_wrapper',
      'table.tbl', // เพิ่ม element 'table' ที่มี class="tbl"
      'tr', // เพิ่ม element 'tr'
      'tr td', // เพิ่ม element 'td' ภายใน 'tr'
      'div.table-responsive',
      'class.table-responsive',
      'table-responsive',
      'tbody',
      'div.rate-area',
      'td',
    ];
  }

  void showPopup(BuildContext context, String url) {
    String message;
    if (_canAccessURLs[url] == null) {
      message = 'Checking...';
    } else if (_canAccessURLs[url]! && _foundTags[url]!) {
      message = 'Can access the website.\nFound the specified tag.';
    } else if (_canAccessURLs[url]! && !_foundTags[url]!) {
      message = 'Can access the website. \nThe specified tag was not found.';
    } else {
      message = 'URL error, can\'t be accessed.';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('URL check result'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('URL Check')),
      body: Center(
        child: ListView.builder(
          itemCount: urls.length,
          itemBuilder: (context, index) {
            final url = urls[index];
            final urlNames = [
              'Check Url K79exchange',
              'Check Url SiamExchange',
              'Check Url Superrichthailand',
              'Check Url Superrich1965',
              'Check Url Valueplusexchange',
              'Check Url Vasuexchange',
              'Check Url X-one',
            ];
            final urlName = urlNames[index];

            return Padding(
              padding: EdgeInsets.all(5.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: () async {
                    await checkURL(url);
                    showPopup(context, url);
                  },
                  title: Text(
                    urlName,
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: ElevatedButton(
                    onPressed: () async {
                      await checkURL(url);
                      showPopup(context, url);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      shape: CircleBorder(),
                    ),
                    child: Icon(Icons.link),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
