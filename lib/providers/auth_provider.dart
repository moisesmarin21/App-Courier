import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_session.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService);

  bool isLoading = false;
  AuthSession? session;
  String? error;

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      session = await _authService.login(email, password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', session!.token);
      await prefs.setInt('userType', session!.userTypeId);
      await prefs.setString('fullname', session!.nombre);
      await prefs.setInt('id_sucursal', session!.idSucursal);

    } catch (e) {
      error = 'Credenciales incorrectas';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    session = null;
    notifyListeners();
  }
}
