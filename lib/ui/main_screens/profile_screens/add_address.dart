import 'package:flutter/material.dart';

import '../../../globals.dart';
import '../../../utils.dart';

class AddAddress extends StatefulWidget {
  final Function() onAddAddress;

  AddAddress({@required this.onAddAddress});

  @override
  _AddAddressState createState() => _AddAddressState(
    onAddAddress: onAddAddress,
  );
}

class _AddAddressState extends State<AddAddress> {
  final _key = GlobalKey<FormState>();
  final Function() onAddAddress;

  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _email = '';
  String _address1 = '';
  String _address2 = '';
  String _city = '';
  int _countryId = 0;
  int _stateId = 0;

  int _countryIndex = 0;
  int _stateIndex = 0;

  bool _waiting = false;

  _AddAddressState({@required this.onAddAddress});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Add New Address',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[

                Form(
                  key: _key,
                  child: Column(
                    children: <Widget>[

                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(onEditingComplete: () {
                                FocusScope.of(context).requestFocus(
                                    FocusNode());
                              },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                  ),
                                  labelText: 'First Name',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter the first name.';
                                  } else {
                                    _firstName = value;
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ),

                          //The last name.
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                  ),
                                  labelText: 'Last Name',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter the last name.';
                                  } else {
                                    _lastName = value;
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      // The First name.


                      //The phone.
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                            labelText: 'Phone',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the phone.';
                            } else {
                              _phone = value;
                              return null;
                            }
                          },
                        ),
                      ),

                      //the email
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                            labelText: 'Email',
                          ),
                          validator: (value) {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);

                            if (value.isEmpty) {
                              return 'Please enter the email.';
                            } else if (!regex.hasMatch(value)) {
                              return 'Please enter a valid email';
                            } else {
                              _email = value;
                              return null;
                            }
                          },
                        ),
                      ),

                      //address line 1
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          maxLines: 2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                            labelText: 'Address line 1',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the address.';
                            } else {
                              _address1 = value;
                              return null;
                            }
                          },
                        ),
                      ),

                      //address line 2
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          maxLines: 2,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                            labelText: 'Address line 2',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the address.';
                            } else {
                              _address2 = value;
                              return null;
                            }
                          },
                        ),
                      ),

                      // The city.
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                            labelText: 'The city',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the city.';
                            } else {
                              _city = value;
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                CountryAndCity(
                  onUpdateCountry: (countryId) {
                    _countryId = countryId;
                  },
                  onUpdateState: (stateId) {
                    _stateId = stateId;
                  },
                ),
              ],
            ),
            _waiting
                ? Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              bottom: 0.0,
              child: Container(
                width: 100,
                height: 100,
                child: Column(
                  children: <Widget>[
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            )
                : Container(),
          ],
        ),
        bottomNavigationBar: ListTile(
          onTap: () async {
            if (_key.currentState.validate()) {
              setState(() {
                _waiting = true;
              });
              Map addressAdded = await addAddress(
                firstName: _firstName,
                lastName: _lastName,
                email: _email,
                city: _city,
                stateId: _stateId,
                countryId: _countryId,
                phone: _phone,
                address2: _address2,
                address1: _address1,
              );

              if (addressAdded != null && addressAdded['result']) {
                Map customerDetails =
                await getCustomerDetails(Globals.customerId);

                List addresses = customerDetails['Addresses'];

                Globals.controller.addAddress(addresses[addresses.length - 1]);

                onAddAddress();
                Navigator.of(context).pop();
//                _showUpdateResultDialog(
//                    _context, profileUpdated['user_message']);
              }
            }
          },
          title: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              child: Text(
                'Add Address',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                color: Color(0xff471fa4),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              padding: EdgeInsets.all(10),
            ),
          ),
        ),
      ),
    );
  }
}


class CountryAndCity extends StatefulWidget {

  final Function(int) onUpdateCountry;
  final Function(int) onUpdateState;

  CountryAndCity(
      {@required this.onUpdateCountry, @required this.onUpdateState});

  @override
  _CountryAndCityState createState() =>
      _CountryAndCityState(
        onUpdateCountry: onUpdateCountry,
        onUpdateState: onUpdateState,
      );
}

class _CountryAndCityState extends State<CountryAndCity> {

  int _countryIndex = 0;
  int _stateIndex = 0;

  final Function(int) onUpdateCountry;
  final Function(int) onUpdateState;

  List statesList;
  bool _waiting = false;

  _CountryAndCityState(
      {@required this.onUpdateCountry, @required this.onUpdateState});

  @override
  void initState() {
    super.initState();
    statesList = List();
    onUpdateState(Globals.controller.countries[_countryIndex].id);
    if (Globals.controller.countries[_countryIndex].states.length >= 1) {
      onUpdateState(
          Globals.controller.countries[_countryIndex].states[_stateIndex].id);
    }

    initStatesList();
  }


  initStatesList() async {
    List list = await getStatesFromApi(
        Globals.controller.countries[_countryIndex].id);
    setState(() {
      statesList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text('Country:'),
            ),

            // Countries drop down.
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        10),
                    border: Border.all(
                      color: Colors.black,
                    )),
                child: DropdownButton(
                  onChanged: (index) async {
                    List list = await getStatesFromApi(
                        Globals.controller.countries[index].id);
                    onUpdateCountry(
                        Globals.controller.countries[_countryIndex].id);
                    setState(() {
                      _countryIndex = index;
                      _stateIndex = 0;
                      statesList = list;
                    });
                  },
                  value: _countryIndex,
                  items: List.generate(
                      Globals.controller.countries.length,
                          (index) {
                        return DropdownMenuItem(
                          child: Text(
                              Globals.controller
                                  .countries[index].name),
                          value: index,
                        );
                      }),
                ),
              ),
            ),
            statesList.length >= 1 ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('State:'),
                ),

                Padding(
                  padding: const EdgeInsets.all(
                      10.0),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius
                            .circular(10),
                        border: Border.all(
                          color: Colors.black,
                        )),
                    child: DropdownButton(
                      onChanged: (index) {
                        setState(() {
                          _stateIndex = index;
                        });
                        onUpdateState(statesList[_stateIndex]['Id']);
                      },
                      value: _stateIndex,
                      items: List.generate(statesList.length, (index) {
                        return DropdownMenuItem(
                          child: Text(statesList[index]['Name']),
                          value: index,
                        );
                      }),
                    ),
                  ),
                )
              ],
            ) :
            Container(),
          ],
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
    );
  }
}