class Country {
  int _id;
  String _name;

  Country(this._id, this._name);

  Country.fromJson(Map json) {
    _id = json['Id'];
    _name = json['Name'];
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
