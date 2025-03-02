import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:testprojectbc/page/Navbar/ReservationNav.dart';

import '../curinfo2.dart';
import '../login.dart';


class DetailCur extends StatefulWidget {

  @override
  _DetailCur createState() => _DetailCur();
}

class _DetailCur extends State<DetailCur> {
  
  final TextEditingController _searchController = TextEditingController();
  List<String> _currencies = [
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

  List<String> _filteredCurrencies = [];

  @override
  void initState() {
    super.initState();
    _filteredCurrencies.addAll(_currencies);
  }

  void _filterCurrencies(String query) {
    setState(() {
      _filteredCurrencies = _currencies
          .where((currency) =>
              currency.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Currency'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Currency',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _filterCurrencies,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCurrencies.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  // leading: Image.network(
                  //     'https://flagcdn.com/w40/${_filteredCurrencies[index].toLowerCase()}.png'),
                  title: Text(_filteredCurrencies[index]),
                  onTap: () {
                    Navigator.pop(context, _filteredCurrencies[index]);
                    print('result: ${_filteredCurrencies[index]}');
                  },
                  
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
