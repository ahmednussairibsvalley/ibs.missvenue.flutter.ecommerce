

import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
import 'custom_widgets/CustomShowDialog.dart';
import 'sign_up.dart';

import '../utils.dart';

String _email, _password;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _waiting = false;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Scrollbar(
              child: ListView(
                children: <Widget>[
                  Container(
                    color: Color(0xff471fa4),
                    child: Image.asset(
                      'assets/login.png',
                    ),
                  ),
                  _loginForm(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _signUp(),
                  ),
                ],
              ),
            ),
            _waiting?
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
      ),
    );
  }

  Widget _signUp() {
    final _width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.grey,
                  Colors.grey.shade900,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          width: _width - 40,
          height: 1.0,
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            'Don\'t have an account?',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
            child: Text(
              'SIGN UP',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Color(0xff471fa4),
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // The Email Text Field ..
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: _field(Icon(Icons.email), 'Email:', (String value) {
              if (value.isEmpty) {
                return 'Please Enter Your Email';
              }
              _email = value;
              return null;
            }, false),
          ),

          // The Password Text Field ..
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child:
                _field(Icon(Icons.lock_outline), 'Password:', (String value) {
              if (value.isEmpty) {
                return 'Please Enter Your Password';
              }
              _password = value;
              return null;
            }, true),
          ),

          // The Password recovery link ..
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: GestureDetector(
                onTap: (){
                  _showPasswordRecoveryDialog();
                },
                child: Text(
                  'Forgot Your Password?',
                  style: TextStyle(
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                      color: Color(0xff471fa4)),
                ),
              ),
              alignment: Alignment.centerRight,
            ),
          ),

          // The login button ..
          ListTile(
            onTap: () async{
              FocusScope.of(context).requestFocus(FocusNode());
              var connectivityResult = await Connectivity().checkConnectivity();
              if (connectivityResult != ConnectivityResult.mobile &&
                  connectivityResult != ConnectivityResult.wifi){
                _showNoConnectivityDialog();
                return;
              }

              if (_formKey.currentState.validate()) {
                setState(() {
                  _waiting = true;
                });
                Map accepted = await authenticate(_email, _password);


                if(accepted != null && accepted['Login_Result']['login_result'] == true){

                  ///Preparing the products.
                  //---------------------------------------------------------
                  var list = await getSectorsList();
                  Globals.controller.populateSectors(list);

                  for(int i = 0; i < Globals.controller.sectors.length ; i ++){
                    var list = await getCategoriesList(Globals.controller.sectors[i].id);
                    Globals.controller.populateCategories(i, list);
                    for(int j = 0; j < list.length ; j ++){
                      var productsList = await getProductsList(Globals.controller.sectors[i].categories[j].id);
                      Globals.controller.populateProducts(i, j, productsList);

                      var brandsList = await getBrandsList(
                          Globals.controller.sectors[i].categories[j].id);
                      Globals.controller.populateBrands(i, j, brandsList);
                    }
                  }
                  //---------------------------------------------------------

//                  ///Preparing the countries.
//                  /////---------------------------------------------------------
//                  List countriesList = await getCountriesFromApi();
//
//                  Globals.controller.populateCountries(countriesList);
//
//                  for(int i = 0; i < Globals.controller.countries.length; i++){
//                    List statesList = await getStatesFromApi(Globals.controller.countries[i].id);
//                    Globals.controller.populateStates(i, statesList);
//                  }

                  //---------------------------------------------------------

                  ///Preparing the customer data.
                  ///--------------------------------------------------------
//                  Globals.customerId = accepted['Customer']['Customer_Id'];

                  Map customerMap = await getCustomerDetails(
                      accepted['Customer']['Customer_Id']);
                  Globals.controller.initCustomerFromJson(customerMap);
                  Navigator.of(context).pushReplacementNamed('/home');
                } else {
                  setState(() {
                    _waiting = false;
                  });
                  _showInvalidEmailOrPasswordDialog();
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
                    'LOG IN',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Facebook and Google login options ..
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Colors.grey,
                        Colors.grey.shade900,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                width: 100.0,
                height: 1.0,
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  'Or Log In With',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Colors.grey,
                        Colors.grey.shade900,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                width: 100.0,
                height: 1.0,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              ///Facebook Login.
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: GestureDetector(
                  onTap: () async{
                    FocusScope.of(context).requestFocus(FocusNode());
                    var connectivityResult = await Connectivity().checkConnectivity();
                    if (connectivityResult != ConnectivityResult.mobile &&
                        connectivityResult != ConnectivityResult.wifi){
                      _showNoConnectivityDialog();
                      return;
                    }
                    setState(() {
                      _waiting = true;
                    });
                    Map signedInWithFacebook = await loginWithFacebook();
                    if(signedInWithFacebook != null){
                      var list = await getSectorsList();
                      Globals.controller.populateSectors(list);

                      for(int i = 0; i < Globals.controller.sectors.length ; i ++){
                        var list = await getCategoriesList(Globals.controller.sectors[i].id);
                        Globals.controller.populateCategories(i, list);
                        for(int j = 0; j < list.length ; j ++){
                          var productsList = await getProductsList(Globals.controller.sectors[i].categories[j].id);
                          Globals.controller.populateProducts(i, j, productsList);

                          var brandsList = await getBrandsList(Globals
                              .controller.sectors[i].categories[j].id);
                          Globals.controller.populateBrands(i, j, brandsList);
                        }
                      }

                      ///Preparing the countries.
                      /////---------------------------------------------------------
                      List countriesList = await getCountriesFromApi();

                      Globals.controller.populateCountries(countriesList);

//                  for(int i = 0; i < Globals.controller.countries.keys.toList().length; i ++){
//                    print('${Globals.controller.countries[Globals.controller.countries.keys.toList()[i]]}');
//                  }

                      //---------------------------------------------------------


//                      Globals.controller.initCustomer(signedInWithFacebook['id'],
//                          signedInWithFacebook['firstName'], signedInWithFacebook['lastName'],
//                          signedInWithFacebook['email'], '');
                      Map customerMap = await getCustomerDetails(
                          Globals.customerId);
                      Globals.controller.initCustomerFromJson(customerMap);
                      Navigator.of(context).pushReplacementNamed('/home');
                      //debugPrint('${signedInWithFacebook.toString()}');
                    } else {
                      setState(() {
                        _waiting = false;
                      });
                    }
                  },
                  child: Image.asset(
                    'assets/facebook_login.png',
                    height: 50,
                    width: 50,
                  ),
                ),
              ),

              ///Google+ Login
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: GestureDetector(
                  onTap: () async{
                    FocusScope.of(context).requestFocus(FocusNode());
                    var connectivityResult = await Connectivity().checkConnectivity();
                    if (connectivityResult != ConnectivityResult.mobile &&
                        connectivityResult != ConnectivityResult.wifi){
                      _showNoConnectivityDialog();
                      return;
                    }
                    setState(() {
                      _waiting = true;
                    });
                    Map singedInWithGoogle = await loginWithGoogle();
                    if(singedInWithGoogle != null){
                      var list = await getSectorsList();
                      Globals.controller.populateSectors(list);

                      for(int i = 0; i < Globals.controller.sectors.length ; i ++){
                        var list = await getCategoriesList(Globals.controller.sectors[i].id);
                        Globals.controller.populateCategories(i, list);
                        for(int j = 0; j < list.length ; j ++){
                          var productsList = await getProductsList(Globals.controller.sectors[i].categories[j].id);
                          Globals.controller.populateProducts(i, j, productsList);

                          var brandsList = await getBrandsList(Globals
                              .controller.sectors[i].categories[j].id);
                          Globals.controller.populateBrands(i, j, brandsList);
                        }
                      }

                      ///Preparing the countries.
                      /////---------------------------------------------------------
                      List countriesList = await getCountriesFromApi();

                      Globals.controller.populateCountries(countriesList);

//                  for(int i = 0; i < Globals.controller.countries.keys.toList().length; i ++){
//                    print('${Globals.controller.countries[Globals.controller.countries.keys.toList()[i]]}');
//                  }

                      //---------------------------------------------------------
//                      Globals.controller.initCustomer(singedInWithGoogle['id'],
//                          singedInWithGoogle['firstName'], singedInWithGoogle['lastName'],
//                          singedInWithGoogle['email'], '');
                      Map customerMap = await getCustomerDetails(
                          Globals.customerId);
                      Globals.controller.initCustomerFromJson(customerMap);
                      Navigator.of(context).pushReplacementNamed('/home');
                      //debugPrint('${singedInWithGoogle.toString()}');
                    } else {
                      setState(() {
                        _waiting = false;
                      });
                    }
                  },
                  child: Image.asset(
                    'assets/google_login.png',
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _field(Icon icon, String label, Function validator, bool obsecured) {
    return TextFormField(
      obscureText: obsecured,
      decoration: InputDecoration(
        icon: icon,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
          ),
        ),
        labelStyle: TextStyle(
          fontSize: 15,
        ),
        labelText: label,
      ),
      validator: validator,
    );
  }

  _showInvalidEmailOrPasswordDialog(){
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
                        child: Center(child: Text('Invalid',
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
                        child: Text('Invalid email or password.',
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
  _showNoConnectivityDialog(){
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
  _showPasswordRecoveryDialog(){
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final _key = GlobalKey<FormState>();

    String _email;

    showDialog(
        context: context,
        builder: (context){
          return CustomAlertDialog(
            titlePadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.all(0),
            content: Container(
              width: _width /2,
              height: _height / 1.5,

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
                        child: Center(
                          child: Icon(Icons.lock_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          child: Text('You will receive a link to reset your password. Please enter your email address below.',
                            style: TextStyle(
                              color: Color(0xff471fa4),
                              fontSize: 20,
                            ),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                        ),
                      ),
                  ),
                  Form(
                    key: _key,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          labelText: 'Enter your email.',
                        ),
                        validator: (value){
                          if(value.isEmpty){
                            return 'Please enter your email.';
                          } else if (!EmailValidator.validate(value)){
                            return 'Not valid email';
                          }else {
                            _email = value;
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () async {

                      var connectivityResult = await Connectivity().checkConnectivity();
                      if (connectivityResult != ConnectivityResult.mobile &&
                          connectivityResult != ConnectivityResult.wifi){
                        _showNoConnectivityDialog();
                        return;

                      }


                      if(_key.currentState.validate()){

                        Navigator.of(context).pop();

                        setState(() {
                          _waiting = true;
                        });
                        Map sentForPasswordRecovery = await sendForPasswordRecovery(
                            _email);
                        setState(() {
                          _waiting = false;
                        });
                        if (sentForPasswordRecovery != null) {
                          _showPasswordRecoveryResultDialog(
                              _email, sentForPasswordRecovery['user_message']);
                        } else {
                          _showPasswordRecoveryResultDialog(
                              _email, 'Something wrong! .. Please try again.');
                        }

                      }
                      //Navigator.of(context).pop();
                    },
                    title: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        child: Text('Recover',
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

  _showPasswordRecoveryResultDialog(String email, String message) async {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    showDialog(
        builder: (context) {
          return CustomAlertDialog(
            titlePadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.all(0),
            content: Container(
              width: _width / 2,
              height: _height / 2,

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
                        child: Center(
                          child: Icon(Icons.lock_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Container(
                        child: Text(message,
                          textAlign: TextAlign.center,
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
        }, context: context
    );


  }
}
