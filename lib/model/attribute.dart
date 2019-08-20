import 'attribute_value.dart';

class Attribute {
  int _id;
  int _mappingId;
  int _controlType;
  String _name;
  List<AttributeValue> _values;

  Attribute.fromJson(Map json) {
    _id = json['Id'];
    _name = json['Name'];
    _mappingId = json['Mapping_Id'];
    _controlType = json['ControlType'];
    _values = List();

    List values = json['Values'];
    for (int i = 0; i < values.length; i++) {
      _values.add(AttributeValue.fromJson(values[i]));
    }
  }

  List<AttributeValue> get values => _values;

  set values(List<AttributeValue> value) {
    _values = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get controlType => _controlType;

  set controlType(int value) {
    _controlType = value;
  }

  int get mappingId => _mappingId;

  set mappingId(int value) {
    _mappingId = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}
