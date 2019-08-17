import 'address.dart';
import 'cart_item.dart';
import 'order.dart';
import 'product.dart';

class Customer {
  int _id;
  String _firstName;
  String _lastName;
  String _phone;
  String _email;
  List<Order> _orders;
  List<Address> _addresses;
  List<Product> _wishList;
  List<CartItem> _cart;

  Customer(
      this._id, this._firstName, this._lastName, this._email, this._phone) {
    _orders = List();
    _addresses = List();
    _wishList = List();
    _cart = List();
  }

  Customer.fromJson(Map json){
    _id = json['Customer']['Customer_Id'];
    _email = json['Customer']['Email'];
    _phone = json['Customer']['Customer_Phone'];
    String fullName = json['Customer']['FullName'];
    List names = fullName.split(' ');
    if(names.length >= 2){
      _firstName = names[0];
      _lastName = names[1];
    } else if(names.length == 1){
      _firstName = names[0];
      _lastName = '';
    } else {
      _firstName = '';
      _lastName = '';
    }
    _orders = List();
    _addresses = List();
    _wishList = List();
    _cart = List();
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get lastName => _lastName;

  set lastName(String value) {
    _lastName = value;
  }

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  List<CartItem> get cart => _cart;

  List<Product> get wishList => _wishList;

  List<Address> get addresses => _addresses;

  List<Order> get orders => _orders;


}
