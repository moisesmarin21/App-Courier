import 'dart:convert';
import 'package:courier/core/api/api_client.dart';
import 'package:courier/core/api/api_endpoints.dart';
import 'package:courier/models/sucursal.dart';

class SucursalService {
  final ApiClient _apiClient;

  SucursalService(this._apiClient);

  Future<List<Sucursal>> getSucursales() async {
    final response = await _apiClient.get(
      ApiEndpoints.sucursales,
    );

    if (response.statusCode == 200) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data as Map<String, dynamic>;

      final List<dynamic> data = body['data'] ?? [];

      return data.map((e) => Sucursal.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener sucursales');
    }
  }
}
