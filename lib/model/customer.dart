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
    _id = json['Id'];
    _email = json['Email'];
    _phone = json['Mobile'];
    String fullName = json['FullName'];
    List names = fullName.split(' ');
    _firstName = '';
    _lastName = '';
    if (names.length > 1) {
      _firstName = names[0];
      _lastName = names[1];
    } else if (names.length > 0) {
      _firstName = names[0];
    }


    _orders = List();
    _addresses = List();
    _wishList = List();
    _cart = List();

//    List addresses = json['Addresses'];
//    for (int i = 1; i < addresses.length; i ++) {
//      _addresses.add(Address.fromJson(addresses[i]));
//    }
//
//    List wishlists = json['WishList']['Items'];
//    for (int i = 0; i < wishlists.length; i ++) {
//      _wishList.add(Product.fromJson(wishlists[i]['Product']));
//    }
//
//    List cartItems = json['ShoppingCart']['Items'];
//    for (int i = 0; i < cartItems.length; i++) {
//      _cart.add(CartItem.fromJson(cartItems[i]));
//    }
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

  set cart(List<CartItem> value) {
    _cart = value;
  }

  set wishList(List<Product> value) {
    _wishList = value;
  }

  set addresses(List<Address> value) {
    _addresses = value;
  }

  set orders(List<Order> value) {
    _orders = value;
  }


}
