import 'package:courier/models/motorizado.dart';
import 'package:courier/services/user_service.dart';
import 'package:flutter/material.dart';

class UsersProvider extends ChangeNotifier {
  final UserService _service;

  int? idSucursal;

  UsersProvider(this._service);

  List<Motorizado> _motorizados = [];

  bool _isLoading = false;
  String? _error;

  List<Motorizado> get motorizados => _motorizados;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getMotorizados(int idSucursal) async {
    _isLoading = true;
    _error = null;
    this.idSucursal = idSucursal;
    notifyListeners();

    try {
      _motorizados = await _service.getMotorizados(idSucursal);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}