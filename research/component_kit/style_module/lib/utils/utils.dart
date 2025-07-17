// Helper to convert hex or rgba strings to Flutter Color
import 'package:flutter/material.dart';
import 'package:style_module/models/value_model.dart';

Color colorFromJson(Map<String, dynamic> json) {
  final valueModel = ValueModel.fromJson(json);
  if (valueModel.value.startsWith('rgba')) {
    final rgba =
        valueModel.value.replaceAll(RegExp(r'rgba\(|\)'), '').split(',');
    return Color.fromRGBO(
      int.parse(rgba[0].trim()),
      int.parse(rgba[1].trim()),
      int.parse(rgba[2].trim()),
      double.parse(rgba[3].trim()),
    );
  }
  final hex = valueModel.value.replaceAll('#', '');
  return Color(int.parse('FF$hex', radix: 16));
}

String colorToJson(Color color) {
  return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
}

double doubleFromJson(Map<String, dynamic> json) {
  try {
    final valueModel = ValueModel.fromJson(json);
    return double.parse(valueModel.value.replaceAll('px', ''));
  } catch (e) {}
  return 0.0;
}

String fontNameFromJson(Map<String, dynamic> json) {
  final valueModel = ValueModel.fromJson(json);
  return valueModel.value;
}