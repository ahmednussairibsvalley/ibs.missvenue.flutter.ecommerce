class Order{

  int _id;
  String _status;
  DateTime _date;

  Order(this._id, this._status, this._date);

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


}