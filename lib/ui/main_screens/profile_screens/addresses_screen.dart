import 'package:flutter/material.dart';
import 'package:miss_venue/ui/custom_widgets/CustomShowDialog.dart';
import 'package:miss_venue/ui/main_screens/profile_screens/add_address.dart';

import 'add_address.dart';

import '../../../globals.dart';
import '../../../utils.dart';

class Addresses extends StatefulWidget {
  @override
  _AddressesState createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  List _list;

  bool _waiting = false;

  @override
  void initState() {
    super.initState();
    _list = Globals.controller.customer.addresses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
              AddAddress(
                onAddAddress: () {
              _list = Globals.controller.customer.addresses;
                },
              )));
//          _showAddAddressDialog(context,() async {
//            Map customerMap = await getCustomerDetails(Globals.customerId);
//            List addressesList = customerMap['Addresses'];
//            Globals.controller.addAddress(
//                addressesList[addressesList.length - 1]);
//            setState(() {
//              _list = Globals.controller.customer.addresses;
//            });
//          });
        },
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black87
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('+ Add New Address',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  final _firstName = _list[index].firstName;
                  final _lastName = _list[index].lastName;
                  final _address1 = _list[index].address1;
                  final _address2 = _list[index].address2;
                  final _email = _list[index].email;
                  final _phone = _list[index].phone;
                  final _state = _list[index].state.name;
                  final _city = _list[index].city;
                  final _country = _list[index].country.name;
                  return Column(
                    children: <Widget>[
                      AddressItem(
                        email: _email,
                        firstName: _firstName,
                        lastName: _lastName,
                        address1: _address1,
                        address2: _address2,
                        phone: _phone,
                        state: _state,
                        city: _city,
                        country: _country,
                      ),
                      Divider(),
                    ],
                  );
                }),
          ),
          _waiting ?
          Positioned(
            bottom: 0.0,
            top: 0.0,
            right: 0.0,
            left: 0.0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: CircularProgressIndicator(),
                    width: 100,
                    height: 100,
                  )
                ],
              ),
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}

class AddressItem extends StatefulWidget {

  final firstName;
  final lastName;
  final address1;
  final address2;
  final email;
  final phone;
  final state;
  final city;
  final country;

  AddressItem({@required this.firstName, @required this.lastName,
    @required this.address1, @required this.address2,
    @required this.phone, @required this.city, @required this.email,
    @required this.state, @required this.country});
  @override
  _AddressItemState createState() =>
      _AddressItemState(
        firstName: firstName,
        lastName: lastName,
        address1: address1,
        address2: address2,
        phone: phone,
        state: state,
        city: city,
        email: email,
        country: country,
      );
}

class _AddressItemState extends State<AddressItem> {

  final firstName;
  final lastName;
  final address1;
  final address2;
  final email;
  final phone;
  final state;
  final city;
  final country;

  _AddressItemState({@required this.firstName, @required this.lastName,
    @required this.address1, @required this.address2,
    @required this.phone, @required this.city, @required this.email,
    @required this.state, @required this.country});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        trailing: GestureDetector(
          onTap: (){

          },
          child: Text('Edit',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('$firstName ', style: TextStyle(
                  fontSize: 20,
                ),),
                Text('$lastName', style: TextStyle(
                  fontSize: 20,
                ),),
              ],
            ),
            Text(
              email,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              phone,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            address2 == null || address2 == ''
                ? Text(
              address1 != null ? address1 : '',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                : Text(
              address1 != null && address2 != null
                  ? '$address1\n$address2'
                  : '',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
            Text(
              '$city, $state, $country',
              style: TextStyle(
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
