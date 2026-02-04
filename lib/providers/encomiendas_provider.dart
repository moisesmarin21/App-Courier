import 'package:courier/models/encomienda.dart';
import 'package:courier/models/estado.dart';
import 'package:courier/models/historialEstado.dart';
import 'package:courier/models/image.dart';
import 'package:courier/models/precioCalculo.dart';
import 'package:courier/services/encomienda_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class EncomiendasProvider extends ChangeNotifier {
  final EncomiendaService _service;

  EncomiendasProvider(this._service);

  
  int? idSucursal;
  String? fechaInicio;
  String? fechaFin;

  List<Encomienda> _encomiendas = [];
  List<HistorialEstado> _historialEstados = [];
  List<Estado> _estadosDisponibles = [];
  List<Imagen> _imagenesEncomienda = [];
  PrecioCalculo? _precioCalculado;
  PrecioCalculo? get precioCalculado => _precioCalculado;

  bool _isLoading = false;
  String? _error;

  List<Encomienda> get encomiendas => _encomiendas;
  List<HistorialEstado> get historialEstados => _historialEstados;
  List<Estado> get estadoDisponibles => _estadosDisponibles;
  List<Imagen> get imagenesEncomienda => _imagenesEncomienda;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getEncomiendas(int idSucursal, String fechaInicio, String fechaFin) async {
    _isLoading = true;
    _error = null;
    this.idSucursal = idSucursal;
    this.fechaInicio = fechaInicio;
    this.fechaFin = fechaFin;
    notifyListeners();

    try {
      _encomiendas = await _service.getEncomiendas(idSucursal, fechaInicio, fechaFin);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createEncomienda(Encomienda encomienda) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.createEncomienda(encomienda);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getHistorialEstados(int idEncomienda) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _historialEstados = await _service.getHistorialEstados(idEncomienda);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
     }
  }

  Future<void> getEstadosDisponibles(int idEncomienda) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _estadosDisponibles = await _service.getEstadosDisponibles(idEncomienda);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEstadoEncomienda (int idEncomienda, int idEstado, String comentario) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.addEstadoEncomienda(idEncomienda, idEstado, comentario);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> calcularPrecio(double kg, int idCliente, int idDistritoDesti, int idPlan, String tipoEnvio, String tipoEntrega) async {
    _isLoading = true;
    notifyListeners();

    try {
      _precioCalculado = await _service.calcularPrecio(kg, idCliente, idDistritoDesti, idPlan, tipoEnvio, tipoEntrega);
    } catch (e) {
      _precioCalculado = null;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getImagenesEncomienda(int idEncomienda) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _imagenesEncomienda = await _service.getImagenesEncomienda(idEncomienda);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> asignarMotorizadosAEncomienda(int idEncomienda, int idMotorizado1, int idMotorizado2) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.asignarMotorizadosAEncomienda(idEncomienda, idMotorizado1, idMotorizado2);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addImagenEncomienda(FormData formData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.addImagenEncomienda(formData);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
