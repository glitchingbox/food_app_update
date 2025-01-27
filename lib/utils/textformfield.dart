import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const TextFormFieldWidget({
    Key? key,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Adjust padding as needed
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 14), // Replace with `primaryTextStyle` if available
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          hintText: hintText,
          filled: true,
          fillColor: Colors.white, // Replace with `food_white` if available
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0), // Replace with `food_view_color` if available
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Colors.blue, width: 1.0), // Replace with custom color if available
          ),
        ),
      ),
    );
  }
}
