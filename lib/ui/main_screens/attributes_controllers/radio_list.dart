import 'package:flutter/material.dart';

import '../../../globals.dart';

class RadioList extends StatefulWidget {
  final int sectorIndex;
  final int categoryIndex;
  final int productIndex;
  final int attributeIndex;

  RadioList(
      {@required this.sectorIndex,
      @required this.categoryIndex,
      @required this.productIndex,
      @required this.attributeIndex});

  @override
  _RadioListState createState() => _RadioListState(
        sectorIndex: sectorIndex,
        categoryIndex: categoryIndex,
        productIndex: productIndex,
        attributeIndex: attributeIndex,
      );
}

class _RadioListState extends State<RadioList> {
  final int sectorIndex;
  final int categoryIndex;
  final int productIndex;
  final int attributeIndex;

  int _length;

  int _index;

  _RadioListState(
      {@required this.sectorIndex,
      @required this.categoryIndex,
      @required this.productIndex,
      @required this.attributeIndex});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _length = Globals.controller.sectors[sectorIndex].categories[categoryIndex]
        .products[productIndex].attributes[attributeIndex].values.length;
    _index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_length, (index) {
        String _title = Globals
            .controller
            .sectors[sectorIndex]
            .categories[categoryIndex]
            .products[productIndex]
            .attributes[attributeIndex]
            .values[index]
            .name;
        return RadioListTile(
          value: index,
          groupValue: _index,
          title: Text('$_title'),
          onChanged: (value) {
            setState(() {
              _index = value;
            });
          },
        );
      }),
    );
  }
}
