import 'package:flutter/material.dart';

class RadioList extends StatefulWidget {
  final List list;

  RadioList({@required this.list});

  @override
  _RadioListState createState() => _RadioListState(
    list: list,
  );
}

class _RadioListState extends State<RadioList> {
  final List list;

  int _length;

  int _index;

  _RadioListState({@required this.list});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _length = list.length;
    _index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_length, (index) {
        String _title = list[index]['Name'];
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
