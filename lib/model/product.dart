import 'product_specification.dart';
import 'attribute.dart';

class Product{
  int _id;
  String _title;
  double _price;
  int _color;
  String _size;
  double _sellingPrice;
  List _imagesUrls;
  List<ProductSpecification> _specifications;
  List<Attribute> _attributes;

  Product(this._id, this._title, this._price, this._sellingPrice,) {
    _color = 0;
    _size = '';
    _imagesUrls = List();
    _specifications = List();
    _attributes = List();
  }

  Product.fromJson(Map json){
    _id = json['id'];
    _title = json['Name'];
    _price = json['Price'];
    _imagesUrls = json['Images'];
    _sellingPrice = json['SellingPrice'];
    _color = 0;
    _size = '';

    _attributes = List();
    _specifications = List();

    List attributes = json['Attributes'];
    List specs = json['SpecificationAttribute'];

    for (int i = 0; i < attributes.length; i ++) {
      _attributes.add(Attribute.fromJson(attributes[i]));
    }

    for (int i = 0; i < specs.length; i++) {
      ProductSpecification spec = ProductSpecification.fromJson(specs[i]);
      _specifications.add(spec);
    }
  }


  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
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

  List<ProductSpecification> get specifications => _specifications;

  set specifications(List<ProductSpecification> value) {
    _specifications = value;
  }

  List<Attribute> get attributes => _attributes;

  set attributes(List<Attribute> value) {
    _attributes = value;
  }

  List get imagesUrls => _imagesUrls;

  set imagesUrls(List value) {
    _imagesUrls = value;
  }


}