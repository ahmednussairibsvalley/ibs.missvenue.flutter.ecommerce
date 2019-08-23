class State {
  int _id;
  String _name;

  State(this._id, this._name);

  State.fromJson(Map json) {
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
