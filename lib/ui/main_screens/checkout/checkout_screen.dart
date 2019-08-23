import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_io/flutter_card_io.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';

import '../../../globals.dart';
import 'checkout_data.dart';

enum Method{ground, nextDayAir, secondDayAir}
enum payment { cash, credit }

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with TickerProviderStateMixin {

  bool _shipped = false;
  bool _paid = false;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _zipCodeController = TextEditingController();


  final _cardNumberController = MaskedTextController(mask: '0000 0000 0000 0000 0000');
  final _expiryDateController = MaskedTextController(mask: '00/00');
  final _cvvController = MaskedTextController(mask: '000');
  final _cardHolderController = TextEditingController();

  TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  Method _shippingMethod = Method.ground;
  payment _payment = payment.cash;

  int _currentTabIndex = 0;
  @override
  void initState() {
    super.initState();
    if(checkoutData == null)
      checkoutData = Map();
    _tabController = TabController(vsync: this, length: 3);
    if(checkoutData['firstName'] != null)
      _firstNameController.value = _firstNameController.value.copyWith(text: checkoutData['firstName']);

    if(checkoutData['lastName'] != null)
      _lastNameController.value = _lastNameController.value.copyWith(text: checkoutData['lastName']);

    if(checkoutData['email'] != null)
      _emailController.value = _emailController.value.copyWith(text: checkoutData['email']);

    if(checkoutData['mobileNumber'] != null)
      _mobileController.value = _mobileController.value.copyWith(text: checkoutData['mobileNumber']);

    if(checkoutData['country'] != null)
      _countryController.value = _countryController.value.copyWith(text: checkoutData['country']);

    if(checkoutData['city'] != null)
      _cityController.value = _cityController.value.copyWith(text: checkoutData['ciry']);

    if(checkoutData['address'] != null)
      _addressController.value = _addressController.value.copyWith(text: checkoutData['address']);

    if(checkoutData['zipCode'] != null)
      _zipCodeController.value = _zipCodeController.value.copyWith(text: checkoutData['zipCode']);

    if(checkoutData['shippingMethod'] != null){
      _shippingMethod =checkoutData['shippingMethod'];
    }

    if(checkoutData['payment'] != null){
      _payment = checkoutData['payment'];
    }
  }

  @override
  Widget build(BuildContext context) {
    var _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _currentTabIndex,
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Checkout',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        body: Scaffold(
          appBar: TabBar(
              onTap: (i){
                switch(i){
                  case 0: // When tapped on first tab
                    setState(() {
                      _currentTabIndex = i;
                    });
                    break;
                  case 1: // When tapped on second tab
                    if(_shipped){
                      _tabController.animateTo(i);
                      setState(() {
                        _currentTabIndex = i;
                      });
                    } else {
                      _tabController.animateTo(_tabController.previousIndex);
                    }
                    break;
                  case 2: // When tapped on third tab
                    if(_shipped && _paid){
                      _tabController.animateTo(i);
                      setState(() {
                        _currentTabIndex = i;
                      });
                    } else {
                      _tabController.animateTo(_tabController.previousIndex);
                    }
                    break;
                }
              },
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text(
                    'Shipping',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    'Payment',
                    style: TextStyle(color: _shipped?Colors.black:Colors.grey.shade400),
                  ),
                ),
                Tab(
                  child: Text(
                    'Confirmation',
                    style: TextStyle(color: _paid?Colors.black:Colors.grey.shade400),
                  ),
                ),
              ]
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: <Widget>[

              // Shipping Screen
              Scaffold(
                body: ListView(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: TextFormField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                  ),
                                ),
                                labelText: 'First Name',
                              ),
                              validator: (value){
                                if(value.isEmpty){
                                  return 'Please enter your first name';
                                } else {
                                  checkoutData['firstName'] = value;
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: TextFormField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                  ),
                                ),
                                labelText: 'Last Name',
                              ),
                              validator: (value){
                                if(value.isEmpty){
                                  return 'Please enter your last name';
                                } else {
                                  checkoutData['lastName'] = value;
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                  ),
                                ),
                                labelText: 'Email',
                              ),
                              validator: (value){
                                if(value.isEmpty){
                                  return 'Please enter your email';
                                } else {
                                  checkoutData['email'] = value;
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: TextFormField(
                              controller: _mobileController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                  ),
                                ),
                                labelText: 'Mobile Number',
                              ),
                              validator: (value){
                                if(value.isEmpty){
                                  return 'Please enter your mobile number';
                                } else {
                                  checkoutData['mobileNumber'] = value;
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: TextFormField(
                              controller: _countryController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                  ),
                                ),
                                labelText: 'Country',
                              ),
                              validator: (value){
                                if(value.isEmpty){
                                  return 'Please enter your country';
                                } else {
                                  checkoutData['country'] = value;
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: TextFormField(
                              controller: _cityController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                  ),
                                ),
                                labelText: 'City',
                              ),
                              validator: (value){
                                if(value.isEmpty){
                                  return 'Please enter your city';
                                } else {
                                  checkoutData['city'] = value;
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                  ),
                                ),
                                labelText: 'Address',
                              ),
                              validator: (value){
                                if(value.isEmpty){
                                  return 'Please enter your address';
                                } else {
                                  checkoutData['address'] = value;
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: TextFormField(
                              controller: _zipCodeController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                  ),
                                ),
                                labelText: 'Zip / Postal Code',
                              ),
                              validator: (value){
                                if(value.isEmpty){
                                  return 'Please enter your zip / postal code';
                                } else {
                                  checkoutData['zipCode'] = value;
                                  return null;
                                }
                              },
                            ),
                          ),
                          //ShippingMethod(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        color: Colors.grey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 20, ),
                              child: Text('Shipping Method:',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            RadioListTile(
                              groupValue: _shippingMethod,
                              value: Method.ground,
                              title: Text('Ground (00 SR)'),
                              isThreeLine: true,
                              subtitle: Text('Compared to other shipping methods, ground shipping is carried out closer to the earth',),
                              onChanged: (value){
                                setState(() {
                                  checkoutData['shippingMethod'] = value;
                                  _shippingMethod = value;
                                  _currentTabIndex = 0;
                                });
                              },
                            ),
                            RadioListTile(
                              groupValue: _shippingMethod,
                              value: Method.nextDayAir,
                              title: Text('Next Day Air (00 SR)'),
                              subtitle: Text('The one day air shipping'),
                              isThreeLine: true,
                              onChanged: (value){
                                setState(() {
                                  checkoutData['shippingMethod'] = value;
                                  _shippingMethod = value;
                                  _currentTabIndex = 0;
                                });
                              },
                            ),
                            RadioListTile(
                              groupValue: _shippingMethod,
                              value: Method.secondDayAir,
                              title: Text('2nd Day Air (00 SR)'),
                              subtitle: Text('The two day air shipping'),
                              isThreeLine: true,
                              onChanged: (value){
                                setState(() {
                                  checkoutData['shippingMethod'] = value;
                                  _shippingMethod = value;
                                  _currentTabIndex = 0;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: Container(
                  color: Color(0xff471fa4),
                  child: ListTile(
                    onTap: (){
                      FocusScope.of(context).requestFocus(FocusNode());
//                      if(_formKey.currentState.validate()){
//
//                      }
                      setState(() {
                        _shipped = true;
                      });
                      _tabController.animateTo(1);
                    },
                    title: Text(
                      'Continue to Payment',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Payment Screen
              Scaffold(
                body: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.grey.shade400,
                        child: RadioListTile(
                          value: payment.cash,
                          groupValue: _payment,
                          onChanged: (value) {
                            setState(() {
                              checkoutData['payment'] = value;
                              _payment = value;
                              _currentTabIndex = 1;
                            });
                          },
                          title: _radioItem(
                            'Check / Money Order',
                            'Pay by cheque or money order',
                            Image.asset(
                              'assets/cash.png',
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.grey.shade400,
                        child: RadioListTile(
                            value: payment.credit,
                            groupValue: _payment,
                            title: _radioItem('Credit Card', 'Pay by credit / debit card', Image.asset('assets/credit.png', width: 50, height: 50,)),
                            onChanged: (value) {
                              setState(() {
                                setState(() {
                                  checkoutData['payment'] = value;
                                  _payment = value;
                                  _currentTabIndex = 1;
                                });
                              });
                            }),
                      ),
                    ),
                    _payment == payment.credit? Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _cardNumberController,
                                decoration: InputDecoration(
                                  labelText: 'Card Number',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                      )
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Positioned(
                              right: 0.0,
                              left: 0.0,
                              top: 0.0,
                              bottom: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: GestureDetector(
                                  onTap: () async{
                                    Map data = await _scanCard();
                                    debugPrint('The card number is: ${data['cardNumber']}');
                                    _cardNumberController.text = data['cardNumber'];

                                    DateTime expiryDate = DateTime(data['expiryYear'], data['expiryMonth'] + 1, 0);
                                    var formatter = new DateFormat('MM/yy');
                                    _expiryDateController.text = formatter.format(expiryDate);
                                  },
                                  child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Icon(Icons.camera_alt)
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _expiryDateController,
                                  decoration: InputDecoration(
                                      labelText: 'Expiry Date',
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1
                                          )
                                      )
                                  ),
                                  keyboardType: TextInputType.datetime,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _cvvController,
                                  decoration: InputDecoration(
                                      labelText: 'CVV',
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1
                                          )
                                      )
                                  ),
                                  keyboardType: TextInputType.datetime,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _cardHolderController,
                            decoration: InputDecoration(
                                labelText: 'Card Holder Name',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1
                                    )
                                )
                            ),
                          ),
                        ),
                      ],
                    ):
                    _payment == payment.cash? Center(
                      child: Text('Check / Money View'),
                    ):
                    Container()
                  ],
                ),
                bottomNavigationBar: Container(
                  color: Color(0xff471fa4),
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        _paid = true;
                      });
                      _tabController.animateTo(2);
                    },
                    title: Text(
                      'Continue to Confirmation',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Confirmation Screen
              Scaffold(
                body: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Shipping To:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Globals.controller.customer.addresses.length > 0
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${Globals.controller.customer.firstName} ${Globals.controller.customer.lastName}'),
                          Text('${Globals.controller.customer.email}'),
                          Text('+20 110 434 9535'),

                          Text('${Globals.controller.customer.addresses[0]
                              .address1}'),
                          Text('${Globals.controller.customer.addresses[0]
                              .address2}'),
                          Text('${Globals.controller.customer.addresses[0]
                              .city}, ${Globals.controller.customer.addresses[0]
                              .state.name}, ${Globals.controller.customer
                              .addresses[0].country.name}'),

                        ],
                      )
                          : Container(),
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Shipping Method:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _shippingMethod == Method.ground? Text('Ground'):
                            _shippingMethod == Method.nextDayAir? Text('Next Day Air'):
                            _shippingMethod == Method.secondDayAir? Text('Second Day Air'):
                            Text('No Shipping Method Specified'),
                          ),
                        )
                      ],
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Your Order:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      children: List.generate(Globals.controller.customer.cart.length, (index){
                        final int _id = Globals.controller.customer.cart[index].id;
                        final String _title = Globals.controller.customer.cart[index].product.title;
                        final double _price = Globals.controller.customer.cart[index].product.price;
                        final int _quantity = Globals.controller.customer.cart[index].quantity;
                        final String _imageUrl = Globals.controller.customer
                            .cart[index].product.imagesUrls[0];
//                        final int _color = Globals.controller.customer.cart[index].product.color;
//                        final String _size = Globals.controller.customer.cart[index].product.size;
                        final double _sellingPrice = Globals.controller.customer.cart[index].product.sellingPrice;

                        return CartItem(
                          id: _id, title: _title, price: _price, quantity: _quantity, imageUrl: _imageUrl,
                          sellingPrice: _sellingPrice,
                        );
                      }),
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Payment Method:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _payment == payment.cash? Text('Check / Money Order'):
                            _payment == payment.credit? Text('Credit Card'):
                            Text('No Payment Method Specified'),
                          ),
                        )
                      ],
                    ),
                    Container(
                      color: Colors.grey.shade400,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text('Sub Total:'),
                                  ),
                                  Flexible(
                                    child: Text('${Globals.controller.calculateTotalPrice()} SR'),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: _shippingMethod == Method.ground? Text('Shipping(Ground)')
                                    : _shippingMethod == Method.nextDayAir? Text('Shipping(Next Day Air)')
                                    :Text('Shipping(Second Day Air)'),
                                  ),
                                  Flexible(
                                    child: Text('00 SR'),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text('Total Amount:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text('${Globals.controller.calculateTotalPrice()} SR'),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                bottomNavigationBar: Container(
                  color: Color(0xff471fa4),
                  child: ListTile(
                    onTap: (){

                    },
                    title: Text(
                      'Confirm Order',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _radioItem(String title, String subTitle, Image image) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle),
      trailing: image,
    );
  }

  Future<Map> _scanCard() async {
    Map details;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      details = await FlutterCardIo.scanCard({
        "requireExpiry": true,
        "scanExpiry": true,
        "scanInstructions": "Fit the card within the box",
      });

      print('The data is: $details');

    } on PlatformException {
      print("Failed");
      return null;
    } catch(e){
      print('$e');
      return null;
    }

    if (details == null) {
      print("Canceled");
      return null;
    }

    if (!mounted) return null;

    return details;

  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    checkoutData = null;
  }
}

class CartItem extends StatelessWidget {
  final int id;
  final String title;
  final double price;
  final String imageUrl;
  final int quantity;
//  final int color;
//  final String size;
  final double sellingPrice;


  CartItem({this.id,
    this.title,
    this.price,
    this.imageUrl,
    this.quantity,
    this.sellingPrice,

  }
      );

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image(
                              image: NetworkImage(imageUrl),
                              width: 90,
                              height: 80,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 150,
                                  child: Text('$title',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
//                                    Padding(
//                                      padding: const EdgeInsets.only(right: 8.0),
//                                      child: Text('Size: $size',
//                                        style: TextStyle(
//                                          fontSize: 15,
//                                          color: Colors.grey,
//                                        ),
//                                      ),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: Text('Color: ${Globals.controller.getColorName(color)}',
//                                        style: TextStyle(
//                                          fontSize: 15,
//                                          color: Colors.grey,
//                                        ),
//                                      ),
//                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Qty: $quantity',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: sellingPrice < price?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text('${sellingPrice * quantity} SR'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Text('${price * quantity} SR',
                              style: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough
                              ),
                            ),
                          )
                        ],
                      )
                          : Text('${price * quantity} SR'),
                    ),
                  ],
                )
            ),
          ],
        ),

      ],
    );
  }
}
