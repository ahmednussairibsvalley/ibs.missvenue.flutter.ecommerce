import 'package:flutter/material.dart';

import '../../../globals.dart';

class CheckBoxes extends StatelessWidget {
  final int sectorIndex;
  final int categoryIndex;
  final int productIndex;
  final int attributeIndex;

  CheckBoxes(
      {@required this.sectorIndex,
      @required this.categoryIndex,
      @required this.productIndex,
      @required this.attributeIndex});

  @override
  Widget build(BuildContext context) {
    final int _length = Globals
        .controller
        .sectors[sectorIndex]
        .categories[categoryIndex]
        .products[productIndex]
        .attributes[attributeIndex]
        .values
        .length;
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
        bool _checked = Globals
            .controller
            .sectors[sectorIndex]
            .categories[categoryIndex]
            .products[productIndex]
            .attributes[attributeIndex]
            .values[index]
            .preSelected;
        return CheckBoxItem(
          title: _title,
          checked: _checked,
        );
      }),
    );
  }
}

class CheckBoxItem extends StatefulWidget {
  final bool checked;
  final String title;

  CheckBoxItem({@required this.checked, @required this.title});

  @override
  _CheckBoxItemState createState() => _CheckBoxItemState(
        title: title,
        checked: checked,
      );
}

class _CheckBoxItemState extends State<CheckBoxItem> {
  final bool checked;
  final String title;

  bool _checked;

  _CheckBoxItemState({@required this.checked, @required this.title});

  @override
  void initState() {
    super.initState();
    _checked = checked;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      onChanged: (bool value) {
        setState(() {
          _checked = value;
        });
      },
      value: _checked,
      title: Text('$title'),
    );
  }
}
