import 'dart:convert';

import 'package:courier/core/api/api_client.dart';
import 'package:courier/core/api/api_endpoints.dart';
import 'package:courier/models/customer.dart';
import 'package:courier/models/tipoCliente.dart';

class CustomerService {
  final ApiClient api;

  CustomerService(this.api);

  Future<List<Customer>> getCustomers(int idSucursal) async {
    final response = await api.post(
      ApiEndpoints.clientes,
      data: {'id_sucursal': idSucursal},
    );

    final body = response.data is String
        ? jsonDecode(response.data)
        : response.data as Map<String, dynamic>;

    final List<dynamic> lista = body['data'] ?? [];

    return lista
        .map((e) => Customer.fromJson(e))
        .toList();
  }

  Future<Customer> getCustomerById(int id) async {
    final response = await api.get(
      '${ApiEndpoints.clienteById}?id=$id',
    );

    if (response.statusCode == 200) {
      final body = response.data is String
        ? jsonDecode(response.data)
        : response.data as Map<String, dynamic>;

      return Customer.fromCustomerByIdJson(body['data']);
    } else {
      throw Exception('Error al obtener cliente por documento');
    }
  }

  Future<List<Customer>> getCustomerByDocument(String nroDocumento) async {
    final response = await api.get(
      '${ApiEndpoints.searchCustomer}?busqueda=$nroDocumento',
    );

    if (response.statusCode == 200) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data as Map<String, dynamic>;

      final List<dynamic> lista = body['data'] ?? [];

      final tipos = lista
          .map((e) => Customer.fromSearchJson(e)).toList();

      return tipos;
    } else {
      throw Exception('Error al obtener cliente por documento');
    }
  }

  Future<void> createCustomer(Customer customer) async {
    final response = await api.post(
      ApiEndpoints.createCustomer,
      data: customer.toJson(),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al registrar cliente');
    }
  }

  // SIN USO
  Future<void> updateCustomer(Customer customer) async {
    final response = await api.put(
      '${ApiEndpoints.customers}/${customer.id}',
      data: customer.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar cliente');
    }
  }

  Future<List<TipoCliente>> getTiposCliente() async {
    final response = await api.get(
      ApiEndpoints.customersType,
    );

    if (response.statusCode == 200) {
      final body = response.data is String
          ? jsonDecode(response.data)
          : response.data as Map<String, dynamic>;

      final List<dynamic> lista = body['data'] ?? [];

      final tipos = lista
          .map((e) => TipoCliente.fromString(e as String))
          .toList();

      return tipos;
    } else {
      throw Exception('Error al obtener tipos de cliente');
    }
  }
}