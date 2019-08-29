import 'package:flutter/material.dart';

class CheckBoxes extends StatelessWidget {
  final List list;

  CheckBoxes({@required this.list});

  @override
  Widget build(BuildContext context) {
    final int _length = list.length;
    return Column(
      children: List.generate(_length, (index) {
        String _title = list[index]['Name'];
        bool _checked = list[index]['IsPreSelected'];
        return _CheckBoxItem(
          title: _title,
          checked: _checked,
        );
      }),
    );
  }
}

class _CheckBoxItem extends StatefulWidget {
  final String title;
  final bool checked;

  _CheckBoxItem({@required this.title, @required this.checked});

  @override
  _CheckBoxItemState createState() => _CheckBoxItemState(
    title: title, checked: checked,
  );
}

class _CheckBoxItemState extends State<_CheckBoxItem> {

  final String title;
  final bool checked;

  bool _checked;

  _CheckBoxItemState({@required this.title, @required this.checked});

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
