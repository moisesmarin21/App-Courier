import 'package:courier/models/department.dart';
import 'package:courier/models/district.dart';
import 'package:courier/models/plan.dart';
import 'package:courier/models/province.dart';
import 'package:courier/models/tipoDetraccion.dart';
import 'package:courier/models/tipoEntrega.dart';
import 'package:courier/models/tipoEnvio.dart';
import 'package:courier/models/tipoPago.dart';
import 'package:courier/models/infoByDocument.dart';
import 'package:courier/services/configuraciones_service.dart';
import 'package:flutter/material.dart';

class ConfiguracionesProvider extends ChangeNotifier {
  final ConfiguracionesService _service;

  ConfiguracionesProvider(this._service);

  List<TipoDetraccion> _detracciones = [];
  List<Department> _departamentos = [];
  List<Province> _provincias = [];
  List<District> _distritos = [];
  List<TipoPago> _tiposPago = [];
  List<Plan> _planes = [];
  List<TipoEnvio> _tipoEnvio = [];
  List<TipoEntrega> _tipoEntrega = [];

  bool _isLoading = false;
  String? _error;

  List<TipoDetraccion> get detracciones => _detracciones;
  List<Department> get departamentos => _departamentos;
  List<Province> get provincias => _provincias;
  List<District> get distritos => _distritos;
  List<TipoPago> get tiposPago => _tiposPago;
  List<Plan> get planes => _planes;
  List<TipoEnvio> get tiposEnvio => _tipoEnvio;
  List<TipoEntrega> get tiposEntrega => _tipoEntrega;

  Map<String, dynamic>? _clienteInfo;
  Map<String, dynamic>? get clienteInfo => _clienteInfo;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void clearProvincias() {
    _provincias = [];
    notifyListeners();
  }

  void clearDistritos() {
    _distritos = [];
    notifyListeners();
  }

  InfoByDocument? _cliente;
  InfoByDocument? get cliente => _cliente;

  Future<void> getInfoByDni(String dni) async {
    _isLoading = true;
    notifyListeners();

    try {
      final json = await _service.getInfoByDni(dni);
      _cliente = InfoByDocument.fromJsonDni(json);
    } catch (e) {
      _cliente = null;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getInfoByRuc(String ruc) async {
    _isLoading = true;
    notifyListeners();

    try {
      final json = await _service.getInfoByRuc(ruc);
      _cliente = InfoByDocument.fromJsonRuc(json);
      print('USER RUC: $_cliente');
    } catch (e) {
      _cliente = null;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDetracciones() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _detracciones = await _service.getDetracciones();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDepartamentos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _departamentos = await _service.getDepartamentos();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProvincias(int idDepartamento) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _provincias = await _service.getProvincias(idDepartamento);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDistritos(int idProvincia) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _distritos = await _service.getDistritos(idProvincia);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProvinciasByNombre(String departamentoNombre) async {
    try {
      final departamento = _departamentos.firstWhere(
        (d) => d.departamento == departamentoNombre,
      );

      await getProvincias(departamento.idDepartamento);
    } catch (e) {
      _error = 'Departamento no encontrado';
      notifyListeners();
    }
  }

  Future<void> getDistritosByNombre(String provinciaNombre) async {
    try {
      final provincia = _provincias.firstWhere(
        (p) => p.provincia == provinciaNombre,
      );

      await getDistritos(provincia.idProvincia);
    } catch (e) {
      _error = 'Provincia no encontrada';
      notifyListeners();
    }
  }

  Future<void> getTiposPago() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tiposPago = await _service.getTiposPago();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPlanes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _planes = await _service.getPlanes();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTiposEnvio() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tipoEnvio = await _service.getTipoEnvio();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTiposEntrega() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tipoEntrega = await _service.getTipoEntrega();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
