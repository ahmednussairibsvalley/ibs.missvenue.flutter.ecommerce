import 'package:flutter/material.dart';

import '../../../globals.dart';

class DropDownList extends StatefulWidget {
  final int sectorIndex;
  final int categoryIndex;
  final int productIndex;
  final int attributeIndex;

  DropDownList(
      {@required this.sectorIndex,
      @required this.categoryIndex,
      @required this.productIndex,
      @required this.attributeIndex});

  @override
  _DropDownListState createState() => _DropDownListState(
        sectorIndex: sectorIndex,
        categoryIndex: categoryIndex,
        productIndex: productIndex,
        attributeIndex: attributeIndex,
      );
}

class _DropDownListState extends State<DropDownList> {
  int _value = 0;

  final int sectorIndex;
  final int categoryIndex;
  final int productIndex;
  final int attributeIndex;

  _DropDownListState(
      {@required this.sectorIndex,
      @required this.categoryIndex,
      @required this.productIndex,
      @required this.attributeIndex});

  @override
  void initState() {
    super.initState();

    _value = Globals.controller.sectors[sectorIndex].categories[categoryIndex]
        .products[productIndex].attributes[attributeIndex].values[0].id;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: _value,
        items: List.generate(
            Globals
                .controller
                .sectors[sectorIndex]
                .categories[categoryIndex]
                .products[productIndex]
                .attributes[attributeIndex]
                .values
                .length, (index) {
          return DropdownMenuItem(
            value: Globals
                .controller
                .sectors[sectorIndex]
                .categories[categoryIndex]
                .products[productIndex]
                .attributes[attributeIndex]
                .values[index]
                .id,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(Globals
                  .controller
                  .sectors[sectorIndex]
                  .categories[categoryIndex]
                  .products[productIndex]
                  .attributes[attributeIndex]
                  .values[index]
                  .name),
            ),
          );
        }),
        onChanged: (index) {
          setState(() {
            _value = index;
          });
        });
  }
}
