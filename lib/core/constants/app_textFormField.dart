import 'package:courier/core/constants/colors.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool requiredField;
  final bool? enabled;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.requiredField = true,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        style: AppStyles.label,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          contentPadding: const EdgeInsets.only(
            top: 18,
            bottom: 6,
          ),
          labelStyle: const TextStyle(
            color: AppColors.primary,
            fontSize: 20,
          ),
          counterText: maxLength != null ? '' : null,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        validator: requiredField
            ? (value) =>
                value == null || value.isEmpty ? 'Campo requerido' : null
            : null,
      ),
    );
  }
}
