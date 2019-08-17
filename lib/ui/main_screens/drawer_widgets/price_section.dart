import 'package:flutter/material.dart';

import 'drawer_globals.dart';

RangeValues _values = RangeValues(0.0, 10000.0);

class Price extends StatefulWidget {
  @override
  _PriceState createState() => _PriceState();
}

class _PriceState extends State<Price> {



  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Container(
        padding: EdgeInsets.all(titlePadding),
        alignment: Alignment.centerLeft,
        child: Text('Price', style: TextStyle(fontSize: 23),),
      ),
      children: <Widget>[
        RangeSlider(
          values: _values,
          min: 0.0,
          max: 10000.0,
          onChanged: (RangeValues value) {
            setState(() {
              _values = value;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _priceItem(_values.start),
              _priceItem(_values.end),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceItem(double price){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        )
      ),
      child: Text('${price.toStringAsFixed(0)} RS'),
    );
  }
}
