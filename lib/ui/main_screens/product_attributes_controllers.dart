import 'package:flutter/material.dart';

class AttributesController {
  ///Dropdown list control type
  static int dropDownListControlType = 1;

  ///Radio list control type
  static int radioListControlType = 2;

  ///Check boxes control type
  static int checkboxesControlType = 3;

  /// Textbox control type
  static int textboxControlType = 4;

  /// Multi-Textbox control type
  static int multiTextboxControlType = 10;

  ///Date picker control type
  static int datePickerControlType = 20;

  ///File upload control type
  static int fileUploadControlType = 30;

  ///Color Patterns control type
  static int colorPatternControlType = 40;

  ///Image patterns control type
  static int imagesPatternControlType = 45;

  ///Read-Only check boxes control type
  static int readOnlyCheckBoxesControlType = 50;

  static Widget controller(int controllerType, String controllerName,
      {@required Map map, @required Function(int) onChange}) {
    Widget _controller;
    switch (controllerType) {
      case 1:
        _controller = dropDownWidget(map, onChange);
        break;
    }
    return _controller;
  }

  static Widget dropDownWidget(
      Map<int, String> values, Function(int) onChange) {
    return DropdownButton(
      items: List.generate(values.values.length, (index) {
        return DropdownMenuItem(
          value: values.keys.toList()[index],
          child: Text(
            values.values.toList()[index],
            textAlign: TextAlign.center,
          ),
        );
      }),
      onChanged: onChange,
      value: values.keys.toList()[0],
    );
  }
}
