import 'package:flutter/material.dart';

Widget buildLogo() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Image.network(
      'https://firebasestorage.googleapis.com/v0/b/polismart-6f6ee.appspot.com/o/logo.png?alt=media&token=10ca46a6-b6f8-4046-b8c0-457c1ee70bb6',
      width: 200.0,
      height: 200.0,
    ),
  );
}
