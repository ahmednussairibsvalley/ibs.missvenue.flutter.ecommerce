import 'package:flutter/material.dart';

import 'drawer_globals.dart';
import 'filter_data/size_entry.dart';

final sizes = [
  SizeEntry('S', false),
  SizeEntry('M', false),
  SizeEntry('L', false),
  SizeEntry('XL', false),
  SizeEntry('XXL', false),
];

class Sizes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(titlePadding),
        child: Text('Size',
          style: TextStyle(
            fontSize: 23,
          ),
        ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1,
            ),
            children: List.generate(sizes.length, (index){
              return SizeItem(entry: sizes[index]);
            }),
          ),
        ),
      ],
    );

  }
}


class SizeItem extends StatefulWidget {
  final SizeEntry entry;
  SizeItem({Key key, @required this.entry} ) : super(key: key);
  @override
  _SizeItemState createState() => _SizeItemState(this.entry);
}

class _SizeItemState extends State<SizeItem> {
  SizeEntry _entry;
  _SizeItemState(this._entry);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          _entry.checked = _entry.checked?false:true;
        });
      },
      child: _entry.checked?_checkedView():_uncheckedView(),
    );
  }

  Widget _checkedView(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: 70,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          color: Color(0xff231f20),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(_entry.sizeItem,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _uncheckedView(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: 70,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xff231f20),
            width: 1,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(_entry.sizeItem,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xff231f20),
            ),
          ),
        ),
      ),
    );
  }
}
