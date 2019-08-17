class ColorEntry{

  int _colorCode;
  bool _checked;

  ColorEntry(this._colorCode, this._checked);

  bool get checked => _checked;

  set checked(bool value) {
    _checked = value;
  }

  int get colorCode => _colorCode;

  set colorCode(int value) {
    _colorCode = value;
  }


}