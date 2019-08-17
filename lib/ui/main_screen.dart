import 'package:flutter/material.dart';

import '../globals.dart';
import 'main_screens/home_screen.dart';
import 'main_screens/my_cart_screen.dart';
import 'main_screens/offers_screen.dart';
import 'main_screens/profile_screen.dart';
import 'main_screens/wishlist_screen.dart';
import 'ui_globals.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (index){
            if(drawerContext != null){
              Navigator.of(drawerContext).pop();
              drawerContext = null;
            }


            setState(() {

              _index = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer),
              title: Text('Offers'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text('My Cart'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              title: Text('Wishlist'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              title: Text('Profile'),
            ),
          ],
        ),
        body: _index == 4? ProfileScreen():
        _index == 3? WishlistScreen():
        _index == 2? MyCartScreen():
        _index == 1? OffersScreen():
        HomeScreen(),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    Globals.controller = null;
  }
}

