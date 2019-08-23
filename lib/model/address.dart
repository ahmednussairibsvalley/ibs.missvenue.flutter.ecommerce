import 'country.dart';
import 'state.dart';

class Address{
  int _id;
  String _address1;
  String _address2;
  String _phone;
  String _city;
  State _state;
  Country _country;

  Address(this._id, this._address1, this._address2, this._phone, this._city, this._state,
      this._country);


  Address.fromJson(Map json){
    _id = json['address_Id'];
    _address1 = json['Address1'];
    _address2 = json['Address2'];
    _phone = json['PhoneNumber'];
    _city = json['City'];
    _state = State.fromJson(json['StateModel']);
    _country = Country.fromJson(json['CountryModel']);
  }

  int get id => _id;

  set id(int value) {
    _id = value;
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

  Country get country => _country;

  set country(Country value) {
    _country = value;
  }

  State get state => _state;

  set state(State value) {
    _state = value;
  }


}