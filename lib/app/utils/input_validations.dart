import 'package:flutter/services.dart';

class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult({required this.isValid, this.errorMessage});
}

class Validators {
  static ValidationResult validateField({
    required String fieldName,
    required String? value,
    required String Function(String?) rule,
  }) {
    final errorMessage = rule(value);
    return ValidationResult(
      isValid: errorMessage.isEmpty,
      errorMessage: errorMessage.isEmpty ? null : errorMessage,
    );
  }

  static String notEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El campo no puede estar vacío';
    }
    return '';
  }

  static String validDecimal(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El campo no puede estar vacío';
    }
    final parsed = double.tryParse(value);
    if (parsed == null || parsed <= 0) {
      return 'Debe ser un número válido mayor a 0';
    }
    return '';
  }

  static String validInteger(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El campo no puede estar vacío';
    }
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 0) {
      return 'Debe ser un entero válido mayor o igual a 0';
    }
    return '';
  }

  static String validPositiveInteger(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El campo no puede estar vacío';
    }
    final parsed = int.tryParse(value);
    if (parsed == null || parsed <= 0) {
      return 'Debe ser un entero válido mayor a 0';
    }
    return '';
  }
}

class InputFormatters {
  static List<TextInputFormatter> textOnly() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
    ];
  }

  static List<TextInputFormatter> value() {
    return [
      TextInputFormatter.withFunction((oldValue, newValue) {
        final text = newValue.text;
        if (text.isEmpty) return newValue;
        if (text.length == 1 && RegExp(r'^[JVE]$').hasMatch(text)) {
          return newValue;
        }
        if (!RegExp(r'^[JVE][0-9]{0,9}$').hasMatch(text)) {
          return oldValue;
        }
        if (text.length > 10) {
          return oldValue;
        }
        return newValue;
      }),
      FilteringTextInputFormatter.allow(RegExp(r'[JVE0-9]')),
    ];
  }

  static List<TextInputFormatter> numeric() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      TextInputFormatter.withFunction((oldValue, newValue) {
        final text = newValue.text;
        if (text.isEmpty) return newValue;
        if (!RegExp(r'^\d*\.?\d{0,2}$').hasMatch(text)) {
          return oldValue;
        }
        return newValue;
      }),
    ];
  }

  static List<TextInputFormatter> numericCode() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      TextInputFormatter.withFunction(
        (oldValue, newValue) {
          final text = newValue.text;
          if (text.isEmpty) return newValue;
          if (!RegExp(r'^\d+$').hasMatch(text)) {
            return oldValue;
          }
          return newValue;
        },
      ),
    ];
  }
}
