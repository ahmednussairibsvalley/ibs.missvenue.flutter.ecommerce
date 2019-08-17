class Address{
  int _id;
  String _address1;
  String _address2;
  String _phone;
  String _city;
  String _state;
  String _country;

  Address(this._id, this._address1, this._address2, this._phone, this._city, this._state,
      this._country);


  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get country => _country;

  set country(String value) {
    _country = value;
  }

  String get state => _state;

  set state(String value) {
    _state = value;
  }

  String get city => _city;

  set city(String value) {
    _city = value;
  }

  String get address2 => _address2;

  set address2(String value) {
    _address2 = value;
  }

  String get address1 => _address1;

  set address1(String value) {
    _address1 = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }


}