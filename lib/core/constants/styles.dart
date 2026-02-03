import 'package:flutter/material.dart';
import 'colors.dart';

class AppStyles {
  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: 'Montserrat',
  );

  static const TextStyle titleWhite = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.background,
  );

  static const TextStyle labelBlue = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  static const TextStyle subtitleBlue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
  
  static const TextStyle subtitleBlueSubrayado = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary
  );

  static const TextStyle subtitleWhite = TextStyle(
    fontSize: 16,
    color: AppColors.background,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
  );

  static const TextStyle labelBlocked = TextStyle(
    color: AppColors.secondary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat',
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
  );
  

  static const TextStyle error = TextStyle(
    fontSize: 12,
    color: AppColors.error,
  );

  // ESTILOS PARA TEXTOS DE FORMULARIOS
  static const TextStyle inputLabel = TextStyle(
    fontSize: 16,
    color: AppColors.primary,
    fontWeight: FontWeight.w400,
    height: 0.1,
  );

  // ESTILOS PARA TEXTOS DE BOTONES
  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    decoration: TextDecoration.none
  );

  static const TextStyle buttonWhiteText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.background,
    decoration: TextDecoration.none
  );

  // ESTILOS PARA HINTTEXT
  static const TextStyle labelHintText = TextStyle(
    color: AppColors.primary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    fontFamily: 'Montserrat',
  );
}
