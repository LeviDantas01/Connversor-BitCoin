import 'package:flutter/material.dart';

Widget buildTextFild(String label, String prefix, TextEditingController c,
    Function(String f) f) {
  return TextFormField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.amber,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      prefixText: prefix,
    ),
    style: const TextStyle(
      color: Colors.amber,
      fontSize: 25,
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
