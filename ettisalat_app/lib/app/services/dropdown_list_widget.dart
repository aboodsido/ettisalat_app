// Dropdown widget
import 'package:flutter/material.dart';

SizedBox buildDropdownListWidget({
  required dynamic value,
  required List<DropdownMenuItem<String>> items,
  required Function(dynamic) onChanged,
}) {
  return SizedBox(
    width: 155,
    height: 70,
    child: DropdownButtonFormField<String>(
      value: "$value",
      onChanged: onChanged,
      items: items,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 1),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      dropdownColor: Colors.white,
      iconEnabledColor: Colors.blue,
    ),
  );
}
