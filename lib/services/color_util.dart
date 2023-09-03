import 'package:flutter/material.dart';

Color getColorFromFirebaseString(String colorString) {
  final match = RegExp(r'0x([0-9a-fA-F]+)').firstMatch(colorString);
  if (match != null) {
    final hexColor = match.group(1);
    final int? colorValue = int.tryParse(hexColor!, radix: 16);
    if (colorValue != null) {
      return Color(colorValue);
    }
  }
  return Colors.green;
}
