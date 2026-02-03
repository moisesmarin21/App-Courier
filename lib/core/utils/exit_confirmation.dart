import 'package:courier/core/constants/styles.dart';
import 'package:flutter/material.dart';

class ExitConfirmation {
  static Future<bool> show(
    BuildContext context, {
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('¿Descartar cambios?'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('NO', style: AppStyles.buttonText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('SI', style: AppStyles.buttonText),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}