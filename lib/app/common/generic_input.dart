import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenericInput extends StatelessWidget {
  const GenericInput({
    super.key,
    required this.hintText,
    this.onChanged,
    this.prefixIcon,
  });

  final String hintText;
  final ValueChanged<String>? onChanged;
  final Icon? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Expanded(
      child: TextField(
        controller: controller,
        onChanged: (value) {
          if (onChanged != null) {
            onChanged!(value);
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon ?? const Icon(Icons.warning),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16.0,
          ),
        ),
      ),
    );
  }
}

class GenericFormInput extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final IconData icon;
  final Function(String) onChanged;
  final TextEditingController controller;

  const GenericFormInput({
    super.key,
    required this.label,
    required this.keyboardType,
    required this.icon,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 16.0,
        ),
      ),
    );
  }
}


