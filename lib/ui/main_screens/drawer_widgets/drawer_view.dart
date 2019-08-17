import 'package:flutter/material.dart';

import '../../ui_globals.dart';
import 'brands_section.dart';
import 'colors_section.dart';
import 'price_section.dart';
import 'size_section.dart';

class DrawerView extends StatefulWidget {
  @override
  _DrawerViewState createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    if(drawerContext == null){
      drawerContext = context;
    }

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(25),
                color: Color(0xff231f20),
                child: Text(
                  'Clear',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(25),
                color: Color(0xff471fa4),
                child: Text(
                  'Apply Filters',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Scrollbar(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Filter By: ',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                GestureDetector(
                  child: Icon(Icons.close),
                  onTap: () {
                    Navigator.of(context).pop();
                    drawerContext = null;
                  },
                ),
              ],
            ),
            Container(
              height: 1,
              width: _width,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            Brands(),
            Container(
              height: 1,
              width: _width,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            Price(),
            Container(
              height: 1,
              width: _width,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            ColorsSection(),
            Container(
              height: 1,
              width: _width,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            Sizes(),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    drawerContext = null;
  }
}
