import 'package:flutter/material.dart';

import '../models/sucursal.dart';
import '../services/sucursal_service.dart';

class SucursalesProvider extends ChangeNotifier {
  final SucursalService _service;

  SucursalesProvider(this._service);

  List<Sucursal> _sucursales = [];
  
  bool _isLoading = false;
  String? _error;

  List<Sucursal> get sucursales => _sucursales;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSucursales() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _sucursales = await _service.getSucursales();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
