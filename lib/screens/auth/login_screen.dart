import 'package:courier/core/constants/app_textField.dart';
import 'package:courier/core/constants/buttons.dart';
import 'package:courier/core/constants/colors.dart';
import 'package:courier/core/constants/spacing.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:courier/providers/auth_provider.dart';
import 'package:courier/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool _rememberMe = false;

  void onRememberMeChanged(bool? newValue) {
    setState(() {
      _rememberMe = newValue ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool('remember_me') ?? false;
    if (remember) {
      setState(() {
        _rememberMe = true;
        emailCtrl.text = prefs.getString('saved_username') ?? '';
      });
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', _rememberMe);
    if (_rememberMe) {
      await prefs.setString('saved_username', emailCtrl.text.trim());
    } else {
      await prefs.remove('saved_username');
    }
  }

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
              padding: const EdgeInsets.all(30.0),
              child: FormLogin(
                onSaveCredentials: _saveCredentials,
                emailCtrl: emailCtrl,
                passCtrl: passCtrl,
                rememberMe: _rememberMe,
                onRememberMeChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormLogin extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final Future<void> Function() onSaveCredentials;

  const FormLogin({
    super.key,
    required this.emailCtrl,
    required this.passCtrl,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onSaveCredentials,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                            'Iniciar Sesión',
                            style: AppStyles.title,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                Text('Ingrese tus credenciales para ingresar a tu cuenta', style: AppStyles.label),

                const SizedBox(height: AppSpacing.xl),

                Text('Correo', style: AppStyles.inputLabel),
                AppTextField(
                  controller: emailCtrl,
                ),
            
                const SizedBox(height: AppSpacing.xl),

                Text('Contraseña', style: AppStyles.inputLabel),
                AppTextField(
                  controller: passCtrl,
                  obscure: true,
                ),
            
                const SizedBox(height: AppSpacing.md),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.80,
                          child: Checkbox(
                            value: rememberMe,
                            onChanged: onRememberMeChanged,
                            activeColor: AppColors.primary,
                            shape: const CircleBorder(),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          ),
                        ),
                        Text('Recordarme', style: AppStyles.label),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.forgotPassword);
                      },
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: AppStyles.buttonText,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24.0, left: 28.0, right: 28.0),
          child: auth.isLoading
            ? const CircularProgressIndicator()
            : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: AppButtonStyles.secondary,
                  onPressed: () async {
                    await onSaveCredentials();
                    await auth.login(
                      emailCtrl.text,
                      passCtrl.text,
                    );

                    if (auth.session != null) {
                      _handleLogin(context, auth);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Inicio de sesión exitoso")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Usuario o contraseña incorrectos")),
                      );
                    }
                  },
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(color: AppColors.primary)
                  ),
                ),
            ),
        )
      ],
    );
  }
}

void _handleLogin(BuildContext context, AuthProvider auth) {
  final userType = auth.session!.userTypeId;

  switch (userType) {
    case 1:
      Navigator.pushReplacementNamed(context, '/admin');
      break;
    case 2:
      Navigator.pushReplacementNamed(context, '/supervisor');
      break;
    case 5:
      Navigator.pushReplacementNamed(context, '/customerModule');
      break;
    default:
      Navigator.pushReplacementNamed(context, '/unauthorized');
  }
}