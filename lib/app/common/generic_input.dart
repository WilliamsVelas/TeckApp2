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
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 16.0,
        ),
      ),
    );
  }
}

class CustomDropdown<T> extends StatelessWidget {
  final String hintText;
  final T? value;
  final List<T> items;
  final String Function(T) itemTextBuilder;
  final void Function(T?) onChanged;
  final double maxMenuHeight;

  const CustomDropdown({
    Key? key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.itemTextBuilder,
    required this.onChanged,
    this.maxMenuHeight = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        isExpanded: true,
        value: value != null && items.contains(value) ? value : null,
        items: items.isEmpty
            ? null
            : items.map((item) => DropdownMenuItem<T>(
          value: item,
          child: Text(itemTextBuilder(item)),
        )).toList(),
        onChanged: onChanged,
        dropdownColor: Colors.white,
        menuMaxHeight: maxMenuHeight,
      ),
    );
  }
}
