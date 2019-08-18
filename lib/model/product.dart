class Product{
  int _id;
  String _title;
  double _price;
  String _imageUrl;
  int _color;
  String _size;
  double _sellingPrice;

  Product(this._id, this._title, this._imageUrl, this._price, this._sellingPrice){
    _color = 0;
    _size = '';
  }

  Product.fromJson(Map json){
    _id = json['id'];
    _title = json['Name'];
    _price = json['Price'];
    List images = json['Images'];

    images.length > 0 ? _imageUrl = json['Images'][0]: _imageUrl = null;
    _sellingPrice = json['SellingPrice'];
    _color = 0;
    _size = '';

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

  double get sellingPrice => _sellingPrice;

  set sellingPrice(double value) {
    _sellingPrice = value;
  }


}