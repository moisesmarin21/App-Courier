import 'package:courier/core/constants/colors.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:flutter/material.dart';

class AppDropdownbuttonformfield2 extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final EdgeInsetsGeometry? padding;

  const AppDropdownbuttonformfield2({
    super.key,
    required this.controller,
    this.label,
    required this.options,
    required this.onChanged,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
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
            value: controller.text.isEmpty ? null : controller.text,
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
            onChanged: (v) {
              controller.text = v ?? '';
              onChanged(v);
            },
            menuMaxHeight: 200,
            isExpanded: true,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, bottom: 0, left: 0, right: 0),
              isDense: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
