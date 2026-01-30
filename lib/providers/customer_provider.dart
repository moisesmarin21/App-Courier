import 'package:courier/models/customer.dart';
import 'package:courier/models/tipoCliente.dart';
import 'package:courier/services/customer_service.dart';
import 'package:flutter/material.dart';

class CustomersProvider extends ChangeNotifier {
  final CustomerService _service;

  CustomersProvider(this._service);

  List<Customer> _customers = [];
  List<Customer> _customerByDocument = [];
  List<TipoCliente> _customersType = [];

  Customer? _customerById;
  Customer? get customerById => _customerById;

  bool _isLoading = false;
  String? _error;

  List<Customer> get customers => _customers;
  List<Customer> get customerByDocument => _customerByDocument;
  List<TipoCliente> get customersType => _customersType;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getClientes(int idSucursal) async {
    _isLoading = true;
    notifyListeners();

    try {
      _customers = await _service.getCustomers(idSucursal);
    } catch (e) {
      _customers = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getClienteById(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _customerById = await _service.getCustomerById(id);
    } catch (e) {
      _customerById = null;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCustomerByDocument(String nroDocumento) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _customerByDocument = await _service.getCustomerByDocument(nroDocumento);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCustomer(Customer customer) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.createCustomer(customer);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.updateCustomer(customer);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> getCustomersType() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _customersType = await _service.getTiposCliente();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
