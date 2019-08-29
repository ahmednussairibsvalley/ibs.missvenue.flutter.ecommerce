import 'package:flutter/material.dart';

class DropDownList extends StatefulWidget {
  final List list;

  DropDownList({@required this.list});

  @override
  _DropDownListState createState() => _DropDownListState(
      list: list
  );
}

class _DropDownListState extends State<DropDownList> {
  int _value = 0;

  final List list;

  _DropDownListState({@required this.list});

  @override
  void initState() {
    super.initState();

    _value = list[0]['Id'];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: _value,
        items: List.generate(list.length, (index) {
          return DropdownMenuItem(
            value: list[index]['Id'],
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(list[index]['Name']),
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
