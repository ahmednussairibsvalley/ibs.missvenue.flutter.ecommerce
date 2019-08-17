import 'package:flutter/material.dart';

import 'drawer_globals.dart';
import 'filter_data/brands_entry.dart';

final brands = [
  BrandEntry('Lala', false),
  BrandEntry('Jazzy Sunglasses', false),
  BrandEntry('Indira', false),
  BrandEntry('Opio', false),
  BrandEntry('Zara', false),
  BrandEntry('Sabara', false),
];

class Brands extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Container(
        padding: EdgeInsets.all(titlePadding),
        alignment: Alignment.centerLeft,
        child: Text(
          'Brands',
          style: TextStyle(
            fontSize: 23,
          ),
        ),
      ),
      children: <Widget>[
//        BrandItem('All'),
        _brandsGrid(brands),
      ],
    );
  }

  Widget _brandsGrid(List list) {
    return Wrap(
      spacing: 4, // gap between adjacent chips
      runSpacing: 4.0,
      direction: Axis.horizontal,
      verticalDirection: VerticalDirection.down,
      children: List.generate(list.length, (index) {
        return BrandItem(list[index]);
      }),
    );
  }
}

class BrandItem extends StatefulWidget {
  final BrandEntry _entry;
  BrandItem(this._entry);
  @override
  _BrandItemState createState() => _BrandItemState(this._entry);
}

class _BrandItemState extends State<BrandItem> {
  BrandEntry _entry;
  _BrandItemState(this._entry);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
            onTap: () {
              setState(() {
                _entry.checked = _entry.checked ? false : true;
              });
            },
            child: Icon(_entry.checked
                ? Icons.check_box
                : Icons.check_box_outline_blank)),
        Container(
          width: 100,
          child: Text(
            _entry.brandItem,
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }
}
