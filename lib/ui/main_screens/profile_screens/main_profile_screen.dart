import 'package:flutter/material.dart';
import '../../../globals.dart';
import '../../custom_widgets/CustomShowDialog.dart';

class MainProfileScreen extends StatelessWidget {

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.edit, color: Colors.white,),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
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
      body: Column(

        children: <Widget>[
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _field(Icon(Icons.person_outline), '${Globals.controller.customer.firstName} ${Globals.controller.customer.lastName}'),
            ),
          ),
          Divider(),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _field(Icon(Icons.mail_outline,), '${Globals.controller.customer.email}'),
            ),
          ),
          Divider(),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _field(Icon(Icons.phone_android), '${Globals.controller.customer.phone}'),
            ),
          ),
          Divider(),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  _showPasswordRecoveryDialog(context);
                },
                child: _field(Icon(Icons.lock_outline), 'Change Password'),
              ),
            ),
          ),
          Divider(),
        ],
      ),
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

  _showPasswordRecoveryDialog(BuildContext _context){

    final _width = MediaQuery.of(_context).size.width;
    final _height = MediaQuery.of(_context).size.height;

    final _key = GlobalKey<FormState>();

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
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      labelText: 'Old Password.',
                                    ),
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Please enter your old password.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      labelText: 'New Password.',
                                    ),
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Please enter your new password.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      labelText: 'Confirm Password.',
                                    ),
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Please confirm your new password.';
                                      }
                                      return null;
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
                          //Navigator.of(context).pop();
                          _key.currentState.validate();
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
}
