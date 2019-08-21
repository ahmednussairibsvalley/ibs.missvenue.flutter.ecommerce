import 'product.dart';

class CartItem{
  int _id;
  Product _product;
  int _quantity;

  CartItem(this._id, this._product, this._quantity);


  CartItem.fromJson(Map json){
    _id = json['ProductId'];
    _quantity = json['Quantity'];
    _product = Product.fromJson(json['Product']);
  }

  int get quantity => _quantity;

  set quantity(int value) {
    _quantity = value;
  }

  Product get product => _product;

  set product(Product value) {
    _product = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


}