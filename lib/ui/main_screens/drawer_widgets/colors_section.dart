import 'package:flutter/material.dart';
import 'drawer_globals.dart';
import 'filter_data/colors_entry.dart';

// 24c34f green
// fef200 yellow
// ff2851 fuscia
// 0076fe blue
// 231f20 black
// ffffff white
//

final colors = [
  ColorEntry(0xff24c34f, false),
  ColorEntry(0xfffef200, false),
  ColorEntry(0xffff2851, false),
  ColorEntry(0xff0076fe, false),
  ColorEntry(0xff231f20, false),
  ColorEntry(0xffffffff, false),
  ColorEntry(0xff66d3f4, false), // sky
  ColorEntry(0xfffd0003, false), // red
  ColorEntry(0xffa5238d, false), // purple
  ColorEntry(0xffff96db, false), // fushia
  ColorEntry(0xffff9600, false), // pink
  ColorEntry(0xff01b0b3, false), // arctic

];

class ColorsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ExpansionTile(
      title: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(titlePadding),
        child: Text('Color',
          style: TextStyle(
            fontSize: 23,
          ),
        ),
      ),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: GridView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
            ),
            children: List.generate(colors.length, (index) {
              return ColorItem(colors[index]);
            }),
          ),
        ),
      ],
    );
  }
}

class ColorItem extends StatefulWidget {
  final ColorEntry _entry;
  ColorItem(this._entry);
  @override
  _ColorItemState createState() => _ColorItemState(this._entry);
}

class _ColorItemState extends State<ColorItem> {
  double _iconSize = 40;
  ColorEntry _entry;
  _ColorItemState(this._entry);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _entry.checked = _entry.checked ? false : true;
        });
      },
      child: _entry.checked ? _checkedView(_entry.colorCode) : _uncheckedView(_entry.colorCode),
    );
  }

  Widget _checkedView(int color) {
    return color == 0xffffffff?
    Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Icon(
          Icons.radio_button_unchecked,
          size: _iconSize,
          color: Colors.grey,
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          top: 0.0,
          child: Icon(Icons.check, color: Colors.grey, size: 20,),
        )
      ],
    )
    :Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Icon(
          IconData(0xe961, fontFamily: 'CheckedColor'),
          size: _iconSize,
          color: Color(color),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          top: 0.0,
          child: Icon(Icons.check, color: Colors.white, size: 15,),
        )
      ],
    );
  }

  Widget _uncheckedView(int color) {
    return color == 0xffffffff?
    Icon(
      Icons.radio_button_unchecked,
      size: _iconSize,
      color: Colors.grey,
    )
    :Icon(
      Icons.brightness_1,
      size: _iconSize,
      color: Color(color),
    );
  }
}
