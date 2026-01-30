import 'dart:convert';

import 'package:courier/core/api/api_client.dart';
import 'package:courier/core/api/api_endpoints.dart';
import 'package:courier/models/motorizado.dart';

class UserService {
  final ApiClient api;

  UserService(this.api);

  Future<List<Motorizado>> getMotorizados(int idSucursal) async {
    final response = await api.get(
      '${ApiEndpoints.motorizados}?id_sucursal=$idSucursal',
    );

    if (response.statusCode == 200) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data as Map<String, dynamic>;

      final List<dynamic> lista = body['data'] ?? [];

      final tipos = lista
          .map((e) => Motorizado.fromJson(e)).toList();

      return tipos;
    } else {
      throw Exception('Error al obtener encomiendas');
    }
  }
}