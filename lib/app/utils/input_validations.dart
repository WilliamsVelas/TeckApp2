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