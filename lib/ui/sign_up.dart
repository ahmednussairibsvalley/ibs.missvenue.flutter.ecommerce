import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../utils.dart';
import 'custom_widgets/CustomShowDialog.dart';

String _firstName, _lastName, _email, _phone, _password, _passwordConfirm;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _waiting = false;

  ///Shows the failure dialog.
  _showRegistrationFailureDialog(String title) {
    showDialog(
        context: context,
        builder: (context){
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
                      Image.asset('assets/dialog_header.png', fit: BoxFit.cover,),
                      Positioned(
                        right: 0.0,
                        left: 0.0,
                        top: 0.0,
                        bottom: 0.0,
                        child: Center(child: Text('Failure',
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
                    onTap: (){
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

  ///Shows the success dialog.
  _showRegistrationSuccessDialog(String title) {
    showDialog(
        context: context,
        builder: (context){
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
                      Image.asset('assets/dialog_header.png', fit: BoxFit.cover,),
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
                    onTap: (){
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


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Scrollbar(
            child: Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[

                    ///The sign up screen header.
                    Stack(
                      fit: StackFit.passthrough,
                      children: <Widget>[

                        ///The header background.
                        Container(
                          color: Color(0xff471fa4),
                          child: Image.asset(
                            'assets/signup.png',
                          ),
                        ),

                        ///The header back icon.
                        Container(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // The First Name ..
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: _field(Icon(Icons.person_outline), 'First Name:', (value){
                              if(value.isEmpty){
                                return 'Please enter your first name.';
                              } else {
                                _firstName = value;
                              }
                              return null;
                            }, false),
                          ),

                          // The Last Name ..
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: _field(Icon(Icons.person_outline), 'Last Name:', (value){
                              if(value.isEmpty){
                                return 'Please enter your last name.';
                              } else {
                                _lastName = value;
                              }
                              return null;
                            }, false),
                          ),

                          // The Email ..
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: _field(Icon(Icons.email), 'Email Address', (value){
                              if(value.isEmpty){
                                return 'Please enter your email.';
                              } else if (!EmailValidator.validate(value)){
                                return 'Please enter a valid email.';
                              } else {
                                _email = value;
                              }
                              return null;
                            }, false),
                          ),

                          // The Phone ..
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: _field(Icon(Icons.phone_android), 'Phone Number', (value){
                              if(value.isEmpty){
                                return 'Please enter your phone.';
                              } else if(!RegExp(r'(^[0-9]*$)').hasMatch(value)){
                                return 'Please enter a valid phone (enter digits only)';
                              } else {
                                _phone = value;
                              }
                              return null;
                            }, false),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: _field(Icon(Icons.lock_outline), 'Password:', (value){
                              if(value.isEmpty){
                                return 'Please enter your password.';
                              } else {
                                _password = value;
                              }
                              return null;
                            }, true),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: _field(Icon(Icons.lock_outline), 'Confirm Password:', (value){
                              if(value.isEmpty){
                                return 'Please confirm your password.';
                              } else if(value != _password){
                                return 'The password does not match';
                              } else {
                                _passwordConfirm = value;
                              }
                              return null;
                            }, true),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () async{
                                var connectivityResult = await Connectivity().checkConnectivity();
                                if (connectivityResult != ConnectivityResult.mobile &&
                                    connectivityResult != ConnectivityResult.wifi){

                                  _showNoConnectivityDialog(context);
                                  return;
                                }
                                if (_formKey.currentState.validate()) {

                                  setState(() {
                                    _waiting = true;
                                  });

                                  Map registered = await register(_firstName, _lastName,_email, _phone,
                                      _password, _passwordConfirm);

                                  print('$registered');
                                  if (registered != null &&
                                      registered['result']) {
                                    setState(() {
                                      _waiting = false;
                                    });
                                    _showRegistrationSuccessDialog(
                                        registered['result_message']);
                                  } else {
                                    setState(() {
                                      _waiting = false;
                                    });
                                    _showRegistrationFailureDialog(
                                        registered['result_message']);
                                  }




                                }
                              },
                              title: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Color(0xff471fa4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      'SIGN UP',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text.rich(
                              TextSpan(
                                  text: 'You agree to our ',
                                  children: [
                                    TextSpan(
                                        text: 'Terms & Conditions',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                        )
                                    ),
                                  ]
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _waiting?
                  Positioned(
                    top: 0.0,
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ),
                    )
                  )
                  : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(Icon icon, String label, Function validator, bool obsecured) {
    return TextFormField(
      obscureText: obsecured,
      decoration: InputDecoration(
        icon: icon,
        labelStyle: TextStyle(
          fontSize: 15,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
          ),
        ),
        labelText: label,
      ),
      validator: validator,
    );
  }

  _showNoConnectivityDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (context){
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
                      Image.asset('assets/dialog_header.png', fit: BoxFit.cover,),
                      Positioned(
                        right: 0.0,
                        left: 0.0,
                        top: 0.0,
                        bottom: 0.0,
                        child: Center(child: Text('No Connectivity',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Container(
                        child: Text('Please check your internet connection and try again.',
                          style: TextStyle(
                            color: Color(0xff471fa4),
                            fontSize: 20,
                          ),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                      )
                  ),
                  ListTile(
                    onTap: (){
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
