import 'dart:convert';
import 'package:courier/core/api/api_client.dart';
import 'package:courier/core/api/api_endpoints.dart';
import 'package:courier/models/department.dart';
import 'package:courier/models/district.dart';
import 'package:courier/models/plan.dart';
import 'package:courier/models/province.dart';
import 'package:courier/models/tipoDetraccion.dart';
import 'package:courier/models/tipoEntrega.dart';
import 'package:courier/models/tipoEnvio.dart';
import 'package:courier/models/tipoPago.dart';

class ConfiguracionesService {
  final ApiClient _apiClient;

  ConfiguracionesService(this._apiClient);

  Future<Map<String, dynamic>> getInfoByDni(String dni) async {
    final response = await _apiClient.post(
      ApiEndpoints.infoByDni,
      data: {'dni': dni},
    );

    print('Response DNI: ${response.data}');

    final Map<String, dynamic> body =
        response.data is String
            ? jsonDecode(response.data)
            : response.data;

    if (body['data'] == null || body['data']['result'] == null) {
      throw Exception('Respuesta inválida DNI');
    }

    return body['data']['result'];
  }

  Future<Map<String, dynamic>> getInfoByRuc(String ruc) async {
    final response = await _apiClient.post(
      ApiEndpoints.infoByRuc,
      data: {'ruc': ruc},
    );

    final Map<String, dynamic> body =
        response.data is String
            ? jsonDecode(response.data)
            : response.data;

    if (body['data'] == null || body['data']['result'] == null) {
      throw Exception('Respuesta inválida RUC');
    }

    return body['data']['result'];
  }

  Future<List<TipoDetraccion>> getDetracciones() async {
    final response = await _apiClient.get(
      ApiEndpoints.detraccionsType,
    );

    if (response.statusCode == 200) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data as Map<String, dynamic>;

      final List<dynamic> data = body['data'] ?? [];

      return data.map((e) => TipoDetraccion.fromJSON(e)).toList();
    } else {
      throw Exception('Error al obtener detracciones');
    }
  }

  Future<List<Department>> getDepartamentos() async {
    final response = await _apiClient.get(
      ApiEndpoints.departments,
    );

    if (response.statusCode == 200) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data as Map<String, dynamic>;

      final List<dynamic> data = body['data'] ?? [];

      return data.map((e) => Department.fromJSON(e)).toList();
    } else {
      throw Exception('Error al obtener departamentos');
    }
  }

  Future<List<Province>> getProvincias(int idDepartamento) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.provinces}?id_departamento=$idDepartamento',
    );

    if (response.statusCode == 200) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data as Map<String, dynamic>;

      final List<dynamic> data = body['data'] ?? [];

      return data.map((e) => Province.fromJSON(e)).toList();
    } else {
      throw Exception('Error al obtener provincias');
    }
  }

  Future<List<District>> getDistritos(int idProvincia) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.districts}?id_provincia=$idProvincia',
    );

    if (response.statusCode == 200) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data as Map<String, dynamic>;

      final List<dynamic> data = body['data'] ?? [];

      return data.map((e) => District.fromJSON(e)).toList();
    } else {
      throw Exception('Error al obtener distritos');
    }
  }

  Future<List<TipoPago>> getTiposPago() async {
    final response = await _apiClient.get(
      ApiEndpoints.paymentTypes,
    );

    if (response.statusCode == 200) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data as Map<String, dynamic>;

      final List<dynamic> lista = body['data'] ?? [];

      final tipos = lista
          .map((e) => TipoPago.fromString(e as String))
          .toList();

      return tipos;
    } else {
      throw Exception('Error al obtener tipos de pago');
    }
  }

  Future<List<Plan>> getPlanes() async {
    final response = await _apiClient.get(
      ApiEndpoints.planes,
    );

    if (response.statusCode == 200) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data as Map<String, dynamic>;

      final List<dynamic> data = body['data'] ?? [];

      return data.map((e) => Plan.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener planes');
    }
  }

  Future<List<TipoEnvio>> getTipoEnvio() async {
    final response = await _apiClient.get(
      ApiEndpoints.shippingTypes,
    );

    if (response.statusCode == 200) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data as Map<String, dynamic>;

      final List<dynamic> lista = body['data'] ?? [];

      final tipos = lista
          .map((e) => TipoEnvio.fromString(e as String))
          .toList();

      return tipos;
    } else {
      throw Exception('Error al obtener tipos de pago');
    }
  }

  Future<List<TipoEntrega>> getTipoEntrega() async {
    final response = await _apiClient.get(
      ApiEndpoints.deliveyTypes,
    );

    if (response.statusCode == 200) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data as Map<String, dynamic>;

      final List<dynamic> lista = body['data'] ?? [];

      final tipos = lista
          .map((e) => TipoEntrega.fromString(e as String))
          .toList();

      return tipos;
    } else {
      throw Exception('Error al obtener tipos de pago');
    }
  }
}
