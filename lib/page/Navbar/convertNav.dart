import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'package:testprojectbc/models/notifyModel.dart';
import 'package:testprojectbc/page/Setting/notify.dart';
import 'package:http/http.dart' as http;

class CalculatorNav extends StatefulWidget {
  const CalculatorNav({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalculatorNavState createState() => _CalculatorNavState();
}

class _CalculatorNavState extends State<CalculatorNav> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> _currencies = [
    'AED',
    'AUD',
    'BHD',
    'BND',
    'CAD',
    'CHF',
    'CNY',
    'DKK',
    'EUR',
    'GBP',
    'HKD',
    'IDR',
    'INR',
    'JOD',
    'JPY',
    'KRW',
    'KWD',
    'LAK',
    'MMK',
    'MOP',
    'MYR',
    'NOK',
    'NPR',
    'NZD',
    'OMR',
    'PHP',
    'QAR',
    'RUB',
    'SAR',
    'SEK',
    'SGD',
    'TRY',
    'TWD',
    'USD',
    'VND',
    'ZAR'
  ];
  Map<String, String> imageUrls = {
    'SRO':
        'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_SPRO.png?alt=media&token=bb3a5e94-dcbd-457e-8134-4ce0bc59e65a',
    'SRG':
        'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_SRG.png?alt=media&token=db8f7a00-76fd-4f6b-a49b-56b9393f09ac',
    'VPC':
        'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_VP.png?alt=media&token=f288196a-5abb-422b-b487-85919a4b25f9',
    'K79':
        'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_K79.png?alt=media&token=1c7787bc-dc5b-4e83-8653-830ddcfe5700',
    'SME':
        'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_siam.png?alt=media&token=b26dda49-ed85-4140-822c-40e933dd4f22',
    'VSU':
        'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_vasu.png?alt=media&token=e6da328d-3b95-4f32-bc00-6346e21e1009',
    'XNE':
        'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_xne.png?alt=media&token=15fc6416-5d2f-4e63-9b62-086bd641d006',
  };
  List<Widget> images = [];

  String? _fromCurrency = 'USD';
  String? _toCurrency = 'THB';
  final String? _agenName = '';
  double? _exchangeRate = 0.0;

  double? maxSellRate = 0.0;
  String? maxSellRateAgen = '';
  var highestSellRate = 0.0;

  bool showPadding = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Currency Converter'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.logout),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => notify(),
            ),
          );
        },
        child: Icon(Icons.notifications),
        backgroundColor: Colors.black,
        elevation: 4,
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 1.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/bgnavHome1.jpg'), // เพิ่มรูปภาพที่ต้องการ
                fit: BoxFit.cover,
              ),
            ),
            // height: MediaQuery.of(context).size.height,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 75, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            // onTap: () {
                            //   print('facebook');
                            //   loginWithFacebook(context);
                            // },
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Convert Currency",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 350,
                          height: 400,
                          child: Card(
                            color: Color.fromARGB(0, 255, 255, 255)
                                .withOpacity(0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      DropdownButton<String>(
                                        value: _fromCurrency,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _fromCurrency = value;
                                            print(
                                                'fromCurrency: $_fromCurrency');
                                          });
                                        },
                                        items: _currencies
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.arrow_forward_ios),
                                        onPressed: () {},
                                      ),
                                      DropdownButton<String>(
                                        value: _toCurrency,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _toCurrency = value;
                                            print('toCurrency: $_toCurrency');
                                          });
                                        },
                                        items: [
                                          DropdownMenuItem(
                                            child: Text('THB'),
                                            value: 'THB',
                                          ),
                                          // Add more currencies here
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    controller: _textEditingController,
                                    validator: RequiredValidator(
                                        errorText: "กรุณาใส่ค่าตัวเลข"),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        hintText: '0.00',
                                        hintStyle: TextStyle(fontSize: 30)),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    '${_textEditingController.text} $_fromCurrency = ${((_exchangeRate ?? 0.0) * (double.tryParse(_textEditingController?.text?.toString() ?? '0.0') ?? 0.0)).toStringAsFixed(2)} THB',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    '1 $_fromCurrency = ${(_exchangeRate ?? 0.0).toStringAsFixed(2)} THB',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () async {
                                      highestSellRate = 0.0;
                                      var message = "";
                                      message = "กรุณาใส่ค่าตัวเลข";
                                      if (_textEditingController.text.isEmpty) {
                                        setState(() {
                                          _exchangeRate = 0.0;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(message)));
                                        print('Error: Please enter amount');

                                        Container myContainer() {
                                          return Container(
                                              // Container properties
                                              );
                                        }

                                        return;
                                      } else {
                                        //var apiKey = 'e50a59e299ef0bae5bc03139';
                                        var url =
                                            //'https://v6.exchangerate-api.com/v6/$apiKey/latest/$_fromCurrency';
                                            'https://back-end-rate-thai.vercel.app/getagencies/$_fromCurrency';
                                        var response =
                                            await http.get(Uri.parse(url));
                                        print('before response');
                                        if (response.statusCode == 200) {
                                          print('if response OK');

                                          var jsonResponse =
                                              jsonDecode(response.body);
                                          print(jsonResponse);
                                          if (jsonResponse is List &&
                                              jsonResponse.isNotEmpty) {
                                            var agencies = jsonResponse;
                                            var conversionMap =
                                                Map<String, dynamic>();
                                            for (var agency in agencies) {
                                              if (agency is Map &&
                                                  agency
                                                      .containsKey('agency') &&
                                                  agency is Map &&
                                                  agency.containsKey(
                                                      'agenName')) {
                                                var agencyData =
                                                    agency['agency'];

                                                var agenName =
                                                    agency['agenName'];

                                                if (agencyData is List &&
                                                    agencyData.isNotEmpty) {
                                                  for (var data in agencyData) {
                                                    if (data is Map &&
                                                        data.containsKey(
                                                            'cur') &&
                                                        data.containsKey(
                                                            'sell')) {
                                                      String currency =
                                                          data['cur'];
                                                      double sellRate =
                                                          double.parse(
                                                              data['sell']);
                                                      conversionMap[currency] =
                                                          {
                                                        'agenName': agenName,
                                                        'sellRate': sellRate
                                                      }; // เพิ่ม agenName ลงใน conversionMap พร้อมกับ sellRate
                                                      print(
                                                          "Agen: $agenName // Cur: $currency // Sell: $sellRate");

                                                      for (var entry
                                                          in conversionMap
                                                              .entries) {
                                                        var currency =
                                                            entry.key;
                                                        var value = entry.value;
                                                        var agenName =
                                                            value['agenName'];
                                                        var sellRate =
                                                            value['sellRate'];

                                                        if (sellRate >
                                                            highestSellRate) {
                                                          highestSellRate =
                                                              sellRate; // update the highest sell rate if a higher value is found
                                                          maxSellRateAgen =
                                                              agenName; // update the agenName with the highest sell rate
                                                        }
                                                      }

                                                      setState(() {
                                                        showPadding = true;
                                                        _exchangeRate =
                                                            highestSellRate; // เอาค่า sellRate จาก conversionMap
                                                        print(
                                                            'Agen name: $agenName');
                                                        print(
                                                            'Sell rate: $sellRate');

                                                        print(
                                                            'Invalid currency');
                                                      });
                                                      // String? keepRate = _exchangeRate.toString();
                                                      context
                                                              .read<
                                                                  ReservationData>()
                                                              .notifyCur =
                                                          _fromCurrency!;
                                                      context
                                                              .read<
                                                                  ReservationData>()
                                                              .notifyRate =
                                                          highestSellRate
                                                              .toString();
                                                    }
                                                  }
                                                }
                                              } else {
                                                print('Invalid JSON data');
                                              }
                                            }
                                          }
                                          print(
                                              'Max sell rate Agen name: $maxSellRateAgen // HighestSell: $highestSellRate');
                                        }
                                        if (showPadding) {}
                                      }
                                    },
                                    child: Text(
                                      'Calculate exchange rates',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20),
                                      primary: Colors.black54,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (showPadding)
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: SizedBox(
                              //Box1
                              height: 80,
                              width: MediaQuery.of(context).size.width * 1.0,
                              child: GestureDetector(
                                onTap: () {
                                  print('OK');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => notify(),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: Color.fromARGB(0, 255, 255, 255)
                                      .withOpacity(0.8),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1, // Add a border
                                    ),
                                  ),
                                  elevation: 8, // Add a shadow
                                  // Shows the largest companies and currencies.
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      ),
                                      if (maxSellRateAgen != null &&
                                          highestSellRate != null)
                                        if (maxSellRateAgen == 'SRO')
                                          Image.network(
                                            'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_SPRO.png?alt=media&token=bb3a5e94-dcbd-457e-8134-4ce0bc59e65a',
                                            width: 130,
                                            height: 130,
                                          ),
                                      if (maxSellRateAgen == 'SRG')
                                        Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_SRG.png?alt=media&token=db8f7a00-76fd-4f6b-a49b-56b9393f09ac',
                                          width: 130,
                                          height: 130,
                                        ),
                                      if (maxSellRateAgen == 'VPC')
                                        Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_VP.png?alt=media&token=f288196a-5abb-422b-b487-85919a4b25f9',
                                          width: 130,
                                          height: 130,
                                        ),
                                      if (maxSellRateAgen == 'K79')
                                        Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_K79.png?alt=media&token=1c7787bc-dc5b-4e83-8653-830ddcfe5700',
                                          width: 130,
                                          height: 130,
                                        ),
                                      if (maxSellRateAgen == 'SME')
                                        Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_siam.png?alt=media&token=b26dda49-ed85-4140-822c-40e933dd4f22',
                                          width: 130,
                                          height: 130,
                                        ),
                                      if (maxSellRateAgen == 'VSU')
                                        Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_vasu.png?alt=media&token=e6da328d-3b95-4f32-bc00-6346e21e1009',
                                          width: 130,
                                          height: 130,
                                        ),
                                      if (maxSellRateAgen == 'XNE')
                                        Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Agency%2Ficon_xne.png?alt=media&token=15fc6416-5d2f-4e63-9b62-086bd641d006',
                                          width: 130,
                                          height: 130,
                                        ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 20, 0, 0),
                                              child: Text(
                                                'This agency best exchange rates!',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 5, 0, 0),
                                              child: Text(
                                                '1 $_fromCurrency = ${(_exchangeRate ?? 0.0).toStringAsFixed(2)} THB',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 30, 10, 0),
                                        child: Icon(
                                          FontAwesomeIcons.bell,
                                          size: 22,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
