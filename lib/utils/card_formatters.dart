import 'package:flutter/services.dart';

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1. Remove any non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // 2. Limit to 16 digits
    if (newText.length > 16) {
      newText = newText.substring(0, 16);
    }

    // 3. Add spaces every 4 digits
    final buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      int index = i + 1;
      if (index % 4 == 0 && index != newText.length) {
        buffer.write(' ');
      }
    }

    final String result = buffer.toString();

    // 4. Return new value with cursor at the end
    // (Simple implementation, doesn't preserve cursor in middle edits but safe for end-typing)
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

class CardDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1. Remove any non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // 2. Limit to 4 digits (MMYY)
    if (newText.length > 4) {
      newText = newText.substring(0, 4);
    }

    // 3. Add slash after month
    final buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      int index = i + 1;
      if (index == 2 && index != newText.length) {
        buffer.write('/');
      }
    }

    final String result = buffer.toString();

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
