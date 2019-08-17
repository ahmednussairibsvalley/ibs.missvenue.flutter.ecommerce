class Product{
  int _id;
  String _title;
  double _price;
  String _imageUrl;
  int _color;
  String _size;
  double _discountPecentage;

  Product(this._id, this._title, this._imageUrl, this._price, this._color, this._size, this._discountPecentage);

  Product.fromJson(Map json){
    _id = json['id'];
    _title = json['Name'];
    _price = json['Price'];
    _imageUrl = json['Images'][0];

  }


  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  String get size => _size;

  set size(String value) {
    _size = value;
  }

  int get color => _color;

  set color(int value) {
    _color = value;
  }

  double get discountPecentage => _discountPecentage;

  set discountPecentage(double value) {
    _discountPecentage = value;
  }


}