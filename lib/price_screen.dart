import 'dart:convert';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String rate = '0';
  String selectedCurrency = 'USD';
  late Map<String, dynamic> data;
  var response;
  late Uri url;
  Future<void> getData() async {
    url = Uri.parse(
        'https://rest.coinapi.io/v1/exchangerate/BTC/$selectedCurrency/?apikey=4F808DA0-D235-4073-A8E9-15E8D77F2929');
    response = await http.get(url);
    if (response.statusCode == 200) {
      data = json.decode(response.body);
      setState(() {
        rate = data['rate'].toString();
      });
    } else {
      print('error');
    }
  }

  List<DropdownMenuItem<String>> getDropdownitems() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('🤑 Coin Ticker')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $rate $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: DropdownButton<String>(
              value: selectedCurrency,
              items: getDropdownitems(),
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value.toString();
                });
                getData();
              },
            ),
          ),
        ],
      ),
    );
  }
}
