class Brand {
  int _id;
  String _name;
  String _brandImageUrl;

  Brand(this._id, this._name, this._brandImageUrl);

  Brand.fromJson(Map json) {
    _id = json['id'];
    _name = json['Name'];
    _brandImageUrl = json['image_url'];
  }

  String get brandImageUrl => _brandImageUrl;

  set brandImageUrl(String value) {
    _brandImageUrl = value;
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
