import 'category.dart';

class Sector{
  int _id;
  String _name;
  String _imageUrl;
  List<Category> _categories;

  Sector(this._id, this._name, this._imageUrl){
    _categories = List();
  }

  Sector.fromJson(Map json){
    _id = json['Category_Id'];
    _name = json['Name'];
    _imageUrl = json['PictureUrl'];
    _categories = List();
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

  List<Category> get categories => _categories;

  set categories(List<Category> value) {
    _categories = value;
  }


}