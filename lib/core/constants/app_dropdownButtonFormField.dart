import 'package:courier/core/constants/colors.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:flutter/material.dart';

class AppDropdownbuttonformfield extends StatelessWidget {
  final TextEditingController controller;
  final String? value;
  final String? label;
  final List<String> options;
  final ValueChanged<String?>? onChanged;
  final String? hintText;
  final EdgeInsetsGeometry? padding;

  const AppDropdownbuttonformfield({
    super.key,
    required this.controller,
    this.value,
    this.label,
    required this.options,
    required this.onChanged,
    this.hintText,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final String? safeValue =
        (value != null && options.contains(value)) ? value : null;

    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 28),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: safeValue,
        padding: const EdgeInsets.only(bottom: 0, top: 5),
        hint: Text(
          hintText ?? '',
          style: AppStyles.labelHintText,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 0, top: 10),
          labelStyle: const TextStyle(color: AppColors.primary),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        items: options
            .map(
              (value) => DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: AppStyles.label,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            )
            .toList(),
          menuMaxHeight: 200,
        onChanged: onChanged == null
            ? null
            : (val) {
                controller.text = val ?? '';
                onChanged!(val);
              },
      ),
    );
  }
}
