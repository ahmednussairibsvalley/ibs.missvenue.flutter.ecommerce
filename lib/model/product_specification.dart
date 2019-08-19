class ProductSpecification {
  int _id;
  String _name;
  bool _allowFiltering;
  bool _shownOnProductPage;
  int _displayOrder;
  String _value;

  ProductSpecification(this._id, this._name, this._allowFiltering,
      this._shownOnProductPage, this._displayOrder, this._value);

  ProductSpecification.fromJson(Map json) {
    _id = json['Id'];
    _name = json['Name'];
    _allowFiltering = json['AllowFiltering'];
    _shownOnProductPage = json['ShowOnProductPage'];
    _displayOrder = json['DisplayOrder'];
    _value = json['Value'];
  }

  String get value => _value;

  set value(String value) {
    _value = value;
  }

  int get displayOrder => _displayOrder;

  set displayOrder(int value) {
    _displayOrder = value;
  }

  bool get shownOnProductPage => _shownOnProductPage;

  set shownOnProductPage(bool value) {
    _shownOnProductPage = value;
  }

  bool get allowFiltering => _allowFiltering;

  set allowFiltering(bool value) {
    _allowFiltering = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}
