import 'state.dart';

class Country {
  int _id;
  String _name;
  List<State> _states;

  Country(this._id, this._name) {
    _states = List();
  }

  Country.fromJson(Map json) {
    print('Json equals null: ${json == null}');
    _id = json['Id'];
    _name = json['Name'];
    _states = List();
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  List<State> get states => _states;

  set states(List<State> value) {
    _states = value;
  }


}
