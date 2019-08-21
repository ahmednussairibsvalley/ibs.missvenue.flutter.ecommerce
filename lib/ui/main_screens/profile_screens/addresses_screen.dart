import 'package:flutter/material.dart';

import '../../../globals.dart';

class Addresses extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: (){

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
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ListView.builder(
            itemCount: Globals.controller.customer.addresses.length,
            itemBuilder: (context, index) {
              final _address1 = Globals.controller.customer.addresses[index].address1;
              final _address2 = Globals.controller.customer.addresses[index].address2;
              final _phone = Globals.controller.customer.addresses[index].phone;
              final _state = Globals.controller.customer.addresses[index].state;
              final _city = Globals.controller.customer.addresses[index].city;
              final _country = Globals.controller.customer.addresses[index].country;
              return Column(
                children: <Widget>[
                  AddressItem(_address1, _address2, _phone, _city, _state, _country),
                  Divider(),
                ],
              );
            }),
      ),
    );
  }
}

class AddressItem extends StatefulWidget {

  final _address1;
  final _address2;
  final _phone;
  final _state;
  final _city;
  final _country;

  AddressItem(this._address1, this._address2, this._phone, this._city, this._state, this._country);
  @override
  _AddressItemState createState() => _AddressItemState(_address1, _address2, _phone, _state, _city, _country);
}

class _AddressItemState extends State<AddressItem> {

  final _address1;
  final _address2;
  final _phone;
  final _state;
  final _city;
  final _country;

  _AddressItemState(this._address1, this._address2, this._phone, this._city, this._state, this._country);

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
            Text(
              _phone,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            _address2 == null || _address2 == ''
                ? Text(
              _address1 != null ? _address1 : '',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                : Text(
              _address1 != null && _address2 != null
                  ? '$_address1\n$_address2'
                  : '',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
            Text(
              '$_city, $_state, $_country',
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
