import 'package:flutter/material.dart';

class ControlType1 extends StatefulWidget {
  final Map<int, String> values;

  ControlType1({@required this.values});

  @override
  _ControlType1State createState() => _ControlType1State(values: values);
}

class _ControlType1State extends State<ControlType1> {
  final Map<int, String> values;

  List<int> _keys;
  List<String> _values;

  int _value = 0;

  _ControlType1State({@required this.values});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _keys = values.keys.toList();
    _values = values.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: _value,
        items: List.generate(_keys.length, (index) {
          return DropdownMenuItem(
            value: _keys[index],
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(_values[index]),
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
