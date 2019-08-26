import 'package:flutter/material.dart';

import '../../globals.dart';
import 'profile_screens/addresses_screen.dart';
import 'profile_screens/main_profile_screen.dart';
import 'profile_screens/orders_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Globals.controller.resetCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Account Details',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: TabBar(
              tabs: [
                Tab(
                  child: Text('Profile', style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  ),
                ),
                Tab(
                  child: Text('Orders', style: TextStyle(color: Colors.black, fontSize: 15,),),
                ),
                Tab(
                  child: Text('Addresses', style: TextStyle(color: Colors.black, fontSize: 15,),),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              MainProfileScreen(),
              Orders(),
              Addresses(),
            ],
          ),
        ),
      ),
    );
  }
}
