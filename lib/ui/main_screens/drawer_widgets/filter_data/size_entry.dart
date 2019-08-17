class SizeEntry{
  String _sizeItem;
  bool _checked;

  SizeEntry(this._sizeItem, this._checked);

  bool get checked => _checked;

  set checked(bool value) {
    _checked = value;
  }

  String get sizeItem => _sizeItem;

  set sizeItem(String value) {
    _sizeItem = value;
  }


}