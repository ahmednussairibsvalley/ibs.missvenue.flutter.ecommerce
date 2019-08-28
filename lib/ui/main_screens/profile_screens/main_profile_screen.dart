import 'package:flutter/material.dart';
import 'package:miss_venue/utils.dart';
import '../../../globals.dart';
import '../../custom_widgets/CustomShowDialog.dart';

class MainProfileScreen extends StatefulWidget {
  @override
  _MainProfileScreenState createState() => _MainProfileScreenState();
}

class _MainProfileScreenState extends State<MainProfileScreen> {

  bool _waiting = false;

  String _firstName;
  String _lastName;
  String _phone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstName = Globals.controller.customer.firstName;
    _lastName = Globals.controller.customer.lastName;
    _phone = Globals.controller.customer.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: GestureDetector(
          onTap: () {
            _showProfileUpdateDialog(
                context, onUpdate: (firstName, lastName, phone) {
              setState(() {
                _firstName = firstName;
                _lastName = lastName;
                _phone = phone;
              });
            });
          },
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black87
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.edit, color: Colors.white,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Edit Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            ListView(

              children: <Widget>[
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _field(
                        Icon(Icons.person_outline), '$_firstName $_lastName'),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _field(Icon(Icons.mail_outline,),
                        '${Globals.controller.customer.email}'),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _field(Icon(Icons.phone_android), '$_phone'),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        _showPasswordUpdateDialog(context);
                      },
                      child: _field(
                          Icon(Icons.lock_outline), 'Change Password'),
                    ),
                  ),
                ),
                Divider(),
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
        )
    );
  }

  Widget _field(Icon icon, String value){
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: icon,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }

  _showProfileUpdateDialog(BuildContext _context,
      {@required Function(String, String, String) onUpdate}) {

    final _width = MediaQuery.of(_context).size.width;
    final _height = MediaQuery.of(_context).size.height;

    final _key = GlobalKey<FormState>();

    String firstName = '';
    String lastName = '';
    String phone = '';

    showDialog(
        context: _context,
        builder: (context) {
          return ListView(
            children: <Widget>[
              CustomAlertDialog(
                titlePadding: EdgeInsets.all(0),
                contentPadding: EdgeInsets.all(0),
                content: Container(
                  width: _width * (.5),
                  height: _height * (3 / 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(33.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Image.asset('assets/dialog_header.png',
                                fit: BoxFit.cover,),
                              Positioned(
                                right: 0.0,
                                left: 0.0,
                                top: 0.0,
                                bottom: 0.0,
                                child: Center(
                                  child: Icon(Icons.lock_outline,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Form(
                            key: _key,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      labelText: 'First Name',
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter your first name.';
                                      } else {
                                        firstName = value;
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      labelText: 'Last Name',
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter your last name.';
                                      } else {
                                        lastName = value;
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      labelText: 'Phone',
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter your phone.';
                                      } else {
                                        phone = value;
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        onTap: () async {
                          if (_key.currentState.validate()) {
                            Navigator.of(context).pop();
                            setState(() {
                              _waiting = true;
                            });
                            Map profileUpdated = await updateCustomerProfile(
                                firstName, lastName,
                                Globals.controller.customer.email, phone);

                            if (profileUpdated != null &&
                                profileUpdated['result']) {
                              setState(() {
                                _waiting = false;
                              });
                              onUpdate(firstName, lastName, phone);
                              _showUpdateResultDialog(
                                  _context, profileUpdated['user_message']);
                            }
                          }
                        },
                        title: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: Text('Update Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xff471fa4),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(50)),
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

  _showPasswordUpdateDialog(BuildContext _context) {
    final _width = MediaQuery
        .of(_context)
        .size
        .width;
    final _height = MediaQuery
        .of(_context)
        .size
        .height;

    final _key = GlobalKey<FormState>();

    String oldPassword = '';
    String newPassword = '';

    showDialog(
        context: _context,
        builder: (context){
          return ListView(
            children: <Widget>[
              CustomAlertDialog(
                titlePadding: EdgeInsets.all(0),
                contentPadding: EdgeInsets.all(0),
                content: Container(
                  width: _width * (.5),
                  height: _height * (3/4),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(33.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Image.asset('assets/dialog_header.png', fit: BoxFit.cover,),
                              Positioned(
                                right: 0.0,
                                left: 0.0,
                                top: 0.0,
                                bottom: 0.0,
                                child: Center(
                                  child: Icon(Icons.lock_outline,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Form(
                            key: _key,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      labelText: 'Old Password.',
                                    ),
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Please enter your old password.';
                                      } else {
                                        oldPassword = value;
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      labelText: 'New Password.',
                                    ),
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Please enter your new password.';
                                      } else {
                                        newPassword = value;
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      labelText: 'Confirm Password.',
                                    ),
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Please confirm your new password.';
                                      } else if (value != newPassword) {
                                        return 'Your password does not match the new password you entered.';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        onTap: () async {
                          if (_key.currentState.validate()) {
                            Navigator.of(context).pop();
                            setState(() {
                              _waiting = true;
                            });
                            Map passwordUpdated = await updatePassword(
                                oldPassword, newPassword);

                            if (passwordUpdated != null &&
                                passwordUpdated['result']) {
                              setState(() {
                                _waiting = false;
                              });
                              _showUpdateResultDialog(
                                  _context, passwordUpdated['user_message']);
                            }
                          }
                        },
                        title: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: Text('Change Password',
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
                    ],
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

  _showUpdateResultDialog(BuildContext context, String title) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            titlePadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.all(0),
            content: Container(
              width: 260.0,
              height: 230.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(33.0)),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.asset(
                        'assets/dialog_header.png', fit: BoxFit.cover,),
                      Positioned(
                        right: 0.0,
                        left: 0.0,
                        top: 0.0,
                        bottom: 0.0,
                        child: Center(child: Text('Success',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Container(
                        child: Text(title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff471fa4),
                            fontSize: 20,
                          ),
                        ),
                        alignment: Alignment.center,
                      )
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    title: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        child: Text('Close',
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
                ],
              ),
            ),
          );
        }
    );
  }
}

