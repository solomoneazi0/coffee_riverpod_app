import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'Archivo',
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.black87,
    behavior: SnackBarBehavior.floating,
    // shape: RectangleBorder(
    //   borderRadius: BorderRadius.circular(8),
    // ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
