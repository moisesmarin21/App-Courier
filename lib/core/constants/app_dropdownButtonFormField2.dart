import 'package:courier/core/constants/colors.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:flutter/material.dart';

class AppDropdownbuttonformfield2 extends StatelessWidget {
  final TextEditingController? controller;
  final String? value;
  final String? label;
  final String? hintText;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final EdgeInsetsGeometry? padding;
  final bool? enabled;

  const AppDropdownbuttonformfield2({
    super.key,
    this.controller,
    this.value,
    this.label,
    this.hintText,
    required this.options,
    required this.onChanged,
    this.padding,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final rawValue = value ??
        (controller != null && controller!.text.isNotEmpty
            ? controller!.text
            : null);

    final selectedValue =
        rawValue != null && options.contains(rawValue)
            ? rawValue
            : null;

    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
          DropdownButtonFormField<String>(
            value: selectedValue,
            items: options
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e.toUpperCase(),
                      style: AppStyles.label,
                    ),
                  ),
                )
                .toList(),
            onChanged: enabled == false
                ? null
                : (v) {
                    if (controller != null) {
                      controller!.text = v ?? '';
                    }
                    onChanged(v);
                  },
            menuMaxHeight: 200,
            isExpanded: true,
            hint: Text(
              hintText ?? '',
              style: AppStyles.labelHintText,
            ),
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 10, bottom: 0, left: 0, right: 0),
              isDense: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}