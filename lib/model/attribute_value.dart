class AttributeValue {
  int _id;
  String _name;
  String _colorRgb;
  String _imageUrl;
  double _priceAdjustment;
  double _weightAdjustment;
  double _cost;
  int _displayOrder;
  bool _preSelected;

  AttributeValue(
      this._id,
      this._name,
      this._colorRgb,
      this._imageUrl,
      this._priceAdjustment,
      this._weightAdjustment,
      this._cost,
      this._displayOrder,
      this._preSelected);

  AttributeValue.fromJson(Map json) {
    _id = json['Id'];
    _name = json['Name'];
    _colorRgb = json['ColorSquaresRgb'];
    _imageUrl = json['image_url'];
    _priceAdjustment = json['PriceAdjustment'];
    _weightAdjustment = json['WeightAdjustment'];
    _cost = json['Cost'];
    _displayOrder = json['DisplayOrder'];
    _preSelected = json['IsPreSelected'];
  }

  bool get preSelected => _preSelected;

  set preSelected(bool value) {
    _preSelected = value;
  }

  int get displayOrder => _displayOrder;

  set displayOrder(int value) {
    _displayOrder = value;
  }

  double get cost => _cost;

  set cost(double value) {
    _cost = value;
  }

  double get weightAdjustment => _weightAdjustment;

  set weightAdjustment(double value) {
    _weightAdjustment = value;
  }

  double get priceAdjustment => _priceAdjustment;

  set priceAdjustment(double value) {
    _priceAdjustment = value;
  }

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  String get colorRgb => _colorRgb;

  set colorRgb(String value) {
    _colorRgb = value;
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
