import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.black54,
);

final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(8.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black,
      blurRadius: 4.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kContentPadding = EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0);