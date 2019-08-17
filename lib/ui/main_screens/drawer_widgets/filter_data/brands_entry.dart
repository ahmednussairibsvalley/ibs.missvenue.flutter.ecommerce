class BrandEntry{
  String _brandItem;
  bool _checked;

  BrandEntry(this._brandItem, this._checked);

  bool get checked => _checked;

  set checked(bool value) {
    _checked = value;
  }

  String get brandItem => _brandItem;

  set brandItem(String value) {
    _brandItem = value;
  }


}