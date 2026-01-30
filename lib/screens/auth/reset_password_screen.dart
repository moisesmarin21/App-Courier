import 'package:courier/core/constants/app_textField.dart';
import 'package:courier/core/constants/buttons.dart';
import 'package:courier/core/constants/colors.dart';
import 'package:courier/core/constants/spacing.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final emailCtrl = TextEditingController();
  final code = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
            
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                  
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                  
                                  Text(
                                    'Restablecer Contraseña',
                                    style: AppStyles.title,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
            
                        const SizedBox(height: AppSpacing.xl),
            
                        Text('Correo electrónico', style: AppStyles.inputLabel, textAlign: TextAlign.start,),
                        AppTextField(
                          controller: emailCtrl,
                        ),
            
                        const SizedBox(height: AppSpacing.xl),
            
                        Text('Código de Verificación Via Correo', style: AppStyles.inputLabel),
                        AppTextField(
                          controller: code,
                        ),
            
                        SizedBox(height: AppSpacing.xl),
                        
                        Text('Nueva Contraseña', style: AppStyles.inputLabel),
                        AppTextField(
                          controller: passwordCtrl,
                          obscure: true,
                        ),
            
                        const SizedBox(height: AppSpacing.xl),
            
                        Text('Confirmar Contraseña', style: AppStyles.inputLabel),
                        AppTextField(
                          controller: confirmPasswordCtrl,
                        ),
                        
                        const SizedBox(height: AppSpacing.xl),
            
                        Center(
                          child: ElevatedButton(
                            style: AppButtonStyles.primary,
                            onPressed: () {
                              // Lógica para restablecer la contraseña
                            },
                            child: const Text(
                              'Restablecer Contraseña',
                              style: TextStyle(color: Colors.white)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}