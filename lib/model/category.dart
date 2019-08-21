import 'brand.dart';
import 'product.dart';
class Category{

  int _id;
  String _name;
  String _imageUrl;
  List<Product> _products;
  List<Brand> _brands;

  Category(this._id, this._name, this._imageUrl){
    _products = List();
    _brands = List();
  }

  Category.fromJson(Map json){
    _id = json['Category_Id'];
    _name = json['Name'];
    _imageUrl = json['PictureUrl'];
    _products = List();
    _brands = List();
  }

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  List<Product> get products => _products;

  set products(List<Product> value) {
    _products = value;
  }

  List<Brand> get brands => _brands;

  set brands(List<Brand> value) {
    _brands = value;
  }


}