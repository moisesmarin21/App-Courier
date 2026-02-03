import 'dart:convert';
import 'package:courier/core/api/api_client.dart';
import 'package:courier/core/api/api_endpoints.dart';
import 'package:courier/models/encomienda.dart';
import 'package:courier/models/estado.dart';
import 'package:courier/models/historialEstado.dart';
import 'package:courier/models/precioCalculo.dart';

class EncomiendaService {
  final ApiClient api;

  EncomiendaService(this.api);

  Future<List<Encomienda>> getEncomiendas(int idSucursal, String fechaInicio, String fechaFin) async {
    final response = await api.get(
      '${ApiEndpoints.encomiendas}?id_sucursal=$idSucursal&fecha_inicio=$fechaInicio&fecha_fin=$fechaFin',
    );

    if (response.statusCode == 200) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data as Map<String, dynamic>;

      final List<dynamic> lista = body['data'] ?? [];

      final tipos = lista
          .map((e) => Encomienda.fromJson(e)).toList();

      return tipos;
    } else {
      throw Exception('Error al obtener encomiendas');
    }
  }

  Future<void> createEncomienda(Encomienda encomienda) async {
    final response = await api.post(
      ApiEndpoints.createEncomienda,
      data: encomienda.toJson(),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al registrar encomienda');
    }
  }

  Future<List<HistorialEstado>> getHistorialEstados(String idEncomienda) async {
    final response = await api.get(
      '${ApiEndpoints.historialEstados}?id_encomienda=$idEncomienda',
    );

    if (response.statusCode == 200) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data as Map<String, dynamic>;

      final List<dynamic> lista = body['data'] ?? [];

      final tipos = lista.map((e) => HistorialEstado.fromJson(e)).toList();

      return tipos;
    } else {
      throw Exception('Error al obtener historial de encomienda');
    }
  }

  Future<List<Estado>> getEstadosDisponibles(String idEncomienda) async {
    final response = await api.get(
      '${ApiEndpoints.estadoDisponibles}?id_encomienda=$idEncomienda',
    );

    if (response.statusCode == 200) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data as Map<String, dynamic>;

      final List<dynamic> lista = body['data'] ?? [];

      final tipos = lista
          .map((e) => Estado.fromJson(e)).toList();

      return tipos;
    } else {
      throw Exception('Error al obtener estados disponibles de encomienda');
    }
  }

  Future<void> addEstadoEncomienda(int idEncomienda, int idEstado, String comentario) async {
    final response = await api.post(
      ApiEndpoints.newEstado,
      data: {
        "id_encomienda": idEncomienda,
        "id_estado": idEstado,
        "comentario": comentario
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al agregar nuevo estado de encomienda');
    }
  }

  Future<PrecioCalculo> calcularPrecio(double kg, int idCliente, int idDistritoDesti, int idPlan, String tipoEnvio, String tipoEntrega) async {
    final response = await api.post(
      ApiEndpoints.calcularPrecio,
      data: {
        "kilos": kg,
        "id_cliente": idCliente,
        "id_distrito_destino": idDistritoDesti,
        "id_plan": idPlan,
        "tipo_envio": tipoEnvio,
        "tipo_entrega": tipoEntrega
      },
    );

    final body = response.data is String
        ? jsonDecode(response.data)
        : response.data as Map<String, dynamic>;

    return PrecioCalculo.fromJson(body);
  }
}