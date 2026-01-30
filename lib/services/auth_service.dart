import 'dart:convert';

import 'package:courier/core/api/api_client.dart';
import 'package:courier/core/api/api_endpoints.dart';
import 'package:courier/models/auth_session.dart';

class AuthService {
  final ApiClient api;
  String? _token;

  String? get token => _token;

  AuthService(this.api);

  Future<AuthSession> login(String email, String password) async {
    final response = await api.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    final Map<String, dynamic> body =
        response.data is String
            ? jsonDecode(response.data)
            : response.data;

    if (body['data'] == null || body['data']['exito'] != true) {
      throw Exception('Login failed');
    }

    final session = AuthSession(
      token: body['data']['token'],
      userTypeId: body['data']['id_tipo_usuario'],
      nombre: body['data']['fullname'],
      idSucursal: body['data']['id_sucursal'],
    );

    _token = session.token;
    return session;
  }


  Future<void> forgotPassword(String email) async {
    await api.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
  }

  Future<void> resetPassword(String token, String newPassword) async {
    await api.post(
      ApiEndpoints.resetPassword,
      data: {
        'token': token,
        'password': newPassword,
      },
    );
  }
}
