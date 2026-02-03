import 'dart:async';

import 'package:courier/core/constants/app_dropdownButtonFormField.dart';
import 'package:courier/core/constants/app_dropdownButtonFormField2.dart';
import 'package:courier/core/constants/app_textField.dart';
import 'package:courier/core/constants/colors.dart';
import 'package:courier/core/constants/spacing.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:courier/core/widgets/validacion_tipo_envio.dart';
import 'package:courier/models/customer.dart';
import 'package:courier/models/direccion.dart';
import 'package:courier/models/encomienda.dart';
import 'package:courier/providers/auth_provider.dart';
import 'package:courier/providers/configuraciones_provider.dart';
import 'package:courier/providers/customer_provider.dart';
import 'package:courier/providers/encomiendas_provider.dart';
import 'package:courier/providers/sucursales_provider.dart';
import 'package:courier/screens/Modulos/customer/new_customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EncomiendaForm extends StatefulWidget {
  final Encomienda? encomienda;
  final bool isEditing;

  const EncomiendaForm({
    super.key,
    this.encomienda,
    this.isEditing = false,
  });

  @override
  State<EncomiendaForm> createState() => _EncomiendaFormState();
}

class _EncomiendaFormState extends State<EncomiendaForm> {
  final PageController _pageController = PageController();
  final _fechaActual = DateTime.now();

  late final TextEditingController _agenciaCtrl;
  late final TextEditingController _zonaCtrl;
  late final TextEditingController _tipoEnvioCtrl;
  late final TextEditingController _tipoEntregaCtrl;
  late final TextEditingController _tipoClienteCtrl;
  late final TextEditingController _tipoCalculoCtrl;
  late final TextEditingController _tipoPagoCtrl;
  
  late final TextEditingController _departamentoRemiCtrl;
  late final TextEditingController _provinciaRemiCtrl;
  late final TextEditingController _distritoRemiCtrl;
  late final TextEditingController _departamentoDestiCtrl;
  late final TextEditingController _provinciaDestiCtrl;
  late final TextEditingController _distritoDestiCtrl;
  late final TextEditingController _planCtrl;

  String? _departamentoRemiValue;
  String? _provinciaRemiValue;
  String? _distritoRemiValue;
  String? _planRemiValue;
  String? _tipoClienteRemiValue;
  String? _tipoClienteDestiValue;
  String? _departamentoDestiValue;
  String? _provinciaDestiValue;
  String? _distritoDestiValue;
  String? _tipoPagoValueDesti;
  String? _tipoEntregaReal;
  
  String? _direccionAgenciaOrigen;
  String? _distritoNombreAgenciaOrigen;

  int? _distritoRemiId;
  int? _distritoDestiIdCalculo;
  int? _distritoDestiId;
  int? _planId;
  int? _idAgenciaDestiCtrl;
  int? _idClienteRemi;
  int? _idClienteDesti;

  int tipoEntrega = 0;

  Direccion? _direccionRemiSeleccionada;
  Direccion? _direccionDestiSeleccionada;
  late List<Direccion>? direccionesRemi;
  late List<Direccion>? direccionesDesti;

  Timer? _debounceSender;
  Timer? _debounceReceiver;

  bool _precioCalculado = false;
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    
    Future.microtask(() {
      Provider.of<SucursalesProvider>(context, listen: false).fetchSucursales();
      Provider.of<CustomersProvider>(context, listen: false).getCustomersType();
      Provider.of<ConfiguracionesProvider>(context, listen: false).getTiposEnvio();
      Provider.of<ConfiguracionesProvider>(context, listen: false).getTiposEntrega();
      Provider.of<ConfiguracionesProvider>(context, listen: false).getDepartamentos();
      Provider.of<ConfiguracionesProvider>(context, listen: false).getTiposPago();
      Provider.of<ConfiguracionesProvider>(context, listen: false).getPlanes();
    });

    _departamentoRemiCtrl = TextEditingController(text: ''); 
    _provinciaRemiCtrl = TextEditingController(text: ''); 
    _distritoRemiCtrl = TextEditingController(text: '');
    _departamentoDestiCtrl = TextEditingController(text: ''); 
    _provinciaDestiCtrl = TextEditingController(text: ''); 
    _distritoDestiCtrl = TextEditingController(text: '');
    _planCtrl = TextEditingController(text: '');


    _agenciaCtrl = TextEditingController(text: '');
    _zonaCtrl = TextEditingController(text: '');
    _tipoEnvioCtrl = TextEditingController(text: '');
    _tipoEntregaCtrl = TextEditingController(text: '');
    _tipoClienteCtrl = TextEditingController(text: '');
    _tipoCalculoCtrl = TextEditingController(text: '');
    _tipoPagoCtrl = TextEditingController(text: '');

    _provinciaRemiValue = null;
    _distritoRemiValue = null;
    _departamentoDestiValue = null;
    _provinciaDestiValue = null;
    _distritoDestiValue = null;
    _tipoPagoValueDesti = null;

    _cantidadCtrl.text = "1";
    direccionesRemi = [];
    direccionesDesti = [];
    
    _senderFocusNode = FocusNode();
    _receiverFocusNode = FocusNode();

    _dniRemiCtrl.addListener(_onSenderSearchChanged);
    _dniDestiCtrl.addListener(_onReceiverSearchChanged);
  }
  
  @override
  void dispose() {
    _senderFocusNode.dispose();
    _debounceSender?.cancel();
    _debounceReceiver?.cancel();
    _agenciaCtrl.dispose();
    super.dispose();
  }

  void _onSenderSearchChanged() {
    if (_bloquearBusqueda) return;

    final query = _dniRemiCtrl.text.trim();

    if (_debounceSender?.isActive ?? false) {
      _debounceSender!.cancel();
    }

    if (query.length < 5) {
      setState(() {
        _mostrarResultadosRemi = false;
      });
      return;
    }

    _debounceSender = Timer(const Duration(milliseconds: 600), () async {
      final customersProvider =
          Provider.of<CustomersProvider>(context, listen: false);

      await customersProvider.getCustomerByDocument(query);

      if (!mounted) return;

      setState(() {
        _mostrarResultadosRemi = true;
      });
    });
  }

  Future<void> _selectSender(Customer cliente) async {
    final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
    final configuracionesProvider = Provider.of<ConfiguracionesProvider>(context, listen: false);

    final planes = configuracionesProvider.planes;
    final departamentos = configuracionesProvider.departamentos;

    _bloquearBusqueda = true;
    _senderFocusNode.unfocus();

    await customersProvider.getClienteById(cliente.id!);
    final clienteDetalle = customersProvider.customerById;

    if (clienteDetalle == null) return;

    setState(() {
      _idClienteRemi = cliente.id!;
      _dniRemiCtrl.text = cliente.nroDocumento ?? '';
      _empresaRemiCtrl.text = cliente.nombres!;
      _senderPhoneCtrl.text = clienteDetalle.celular!;
      _planRemiValue = clienteDetalle.planNombre;
      _tipoClienteRemiValue = clienteDetalle.tipoCliente;
      _planCtrl.text = clienteDetalle.planNombre ?? '';
      _mostrarResultadosRemi = false;
      _clienteSeleccionado = true;
    });

    /// PLAN
    if (_planRemiValue != null &&
        _planRemiValue!.trim().isNotEmpty &&
        planes.any((p) => p.plan == _planRemiValue)) {
      final planSeleccionado =
          planes.firstWhere((p) => p.plan == _planRemiValue);
      _planId = planSeleccionado.idPlan;
    } else {
      _planId = null;
      _planRemiValue = null;
      _planCtrl.clear();
    }

    /// UBICACIÓN
    if (tipoEntrega == 4 || tipoEntrega == 2) {
      final dep = clienteDetalle.departamentoNombre;
      final prov = clienteDetalle.provinciaNombre;
      final dist = clienteDetalle.distritoNombre;

      /// DEPARTAMENTO
      if (dep != null &&
          dep.trim().isNotEmpty &&
          departamentos.any((d) => d.departamento == dep)) {
        _cargandoUbicacionRemi = true;

        _departamentoRemiValue = dep;
        _departamentoRemiCtrl.text = dep;

        await configuracionesProvider.getProvinciasByNombre(dep);
        final provinciasCargadas = configuracionesProvider.provincias;

        /// PROVINCIA
        if (prov != null &&
            prov.trim().isNotEmpty &&
            provinciasCargadas.any((p) => p.provincia == prov)) {
          _provinciaRemiValue = prov;
          _provinciaRemiCtrl.text = prov;

          await configuracionesProvider.getDistritosByNombre(prov);
          final distritosCargados = configuracionesProvider.distritos;

          /// DISTRITO
          if (dist != null &&
              dist.trim().isNotEmpty &&
              distritosCargados.any((d) => d.distrito == dist)) {
            final distritoSeleccionado = distritosCargados.firstWhere(
              (d) => d.distrito == dist,
            );

            _distritoRemiId = distritoSeleccionado.idDistrito;
            _distritoRemiValue = dist;
            _distritoRemiCtrl.text = dist;
          } else {
            _distritoRemiValue = null;
            _distritoRemiCtrl.clear();
          }
        } else {
          _provinciaRemiValue = null;
          _provinciaRemiCtrl.clear();
          configuracionesProvider.clearDistritos();
        }
      } else {
        _departamentoRemiValue = null;
        _departamentoRemiCtrl.clear();
        configuracionesProvider.clearProvincias();
        configuracionesProvider.clearDistritos();
      }

      _cargandoUbicacionRemi = false;

      /// DIRECCIONES
      final seen = <String>{};
      direccionesRemi = clienteDetalle.direcciones
          .where((d) => d.direccion.trim().isNotEmpty)
          .where((d) => seen.add(d.direccion.trim()))
          .map(
            (d) => Direccion(
              direccion: d.direccion.trim(),
              referencia: d.referencia?.trim(),
            ),
          )
          .toList();
    }
  }

  Widget _buildSenderResults(CustomersProvider provider) {
    final results = provider.customerByDocument;

    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          'No se encontraron clientes',
          style: AppStyles.labelSmall.copyWith(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: results.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: Colors.grey.shade200),
      itemBuilder: (_, index) {
        final cliente = results[index];

        return InkWell(
          onTap: () => _selectSender(cliente),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cliente.nombres ?? '',
                  style: AppStyles.labelSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  cliente.nroDocumento ?? '',
                  style: AppStyles.labelSmall.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _onReceiverSearchChanged() {
    if (_bloquearBusquedaDesti) return;

    final query = _dniDestiCtrl.text.trim();

    if (_debounceReceiver?.isActive ?? false) {
      _debounceReceiver!.cancel();
    }

    if (query.length < 5) {
      setState(() {
        _mostrarResultadosDesti = false;
      });
      return;
    }

    _debounceReceiver = Timer(const Duration(milliseconds: 600), () async {
      final customersProvider =
          Provider.of<CustomersProvider>(context, listen: false);

      await customersProvider.getCustomerByDocument(query);

      if (!mounted) return;

      setState(() {
        _mostrarResultadosDesti = true;
      });
    });
  }

  void _onTipoPagoChanged(String? value) {
    final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
    final clienteDestiCompleto = customersProvider.customerById;
    setState(() {
      _tipoPagoCtrl.text = value ?? '';
      _tipoPagoValueDesti = value;

      _esDeposito = value == 'deposito';
      if (_esDeposito) {
        _bancoCtrl.text = '';
        _nroOperacionCtrl.text = '';
      } else {
        _bancoCtrl.clear();
        _nroOperacionCtrl.clear();
      }

      _esCredito = value == 'credito';
      if (_esCredito) {
        final tipoPago = clienteDestiCompleto?.tipoPago;

        final dias = int.tryParse(
          tipoPago?.split('_').last ?? '',
        );

        _diasCtrl.text = dias?.toString() ?? '';
      } else {
        _diasCtrl.clear();
      }
    });
  }

  Future<void> _selectReceiver(Customer cliente) async {
    final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
    final configuracionesProvider = Provider.of<ConfiguracionesProvider>(context, listen: false);

    final departamentos = configuracionesProvider.departamentos;

    _bloquearBusquedaDesti = true;
    _receiverFocusNode.unfocus();

    await customersProvider.getClienteById(cliente.id!);
    final clienteDetalle = customersProvider.customerById;

    if (clienteDetalle == null) return;

    final tipoPago = clienteDetalle.tipoPago;


    setState(() {
      _idClienteDesti = cliente.id!;
      _dniDestiCtrl.text = cliente.nroDocumento ?? '';
      _empresaDestiCtrl.text = cliente.nombres!;
      _receiverPhoneCtrl.text = clienteDetalle.celular!;
      _tipoClienteDestiValue = clienteDetalle.tipoCliente;
      _tipoPagoValueDesti = clienteDetalle.tipoPago;
      _mostrarResultadosDesti= false;
      _clienteSeleccionadoDesti = true;
    });

    _onTipoPagoChanged(clienteDetalle.tipoPago);

    /// UBICACIÓN
    if (tipoEntrega == 4 || tipoEntrega == 2) {
      final dep = clienteDetalle.departamentoNombre;
      final prov = clienteDetalle.provinciaNombre;
      final dist = clienteDetalle.distritoNombre;

      /// DEPARTAMENTO
      if (dep != null &&
          dep.trim().isNotEmpty &&
          departamentos.any((d) => d.departamento == dep)) {
        _cargandoUbicacionDesti = true;

        _departamentoDestiValue = dep;
        _departamentoDestiCtrl.text = dep;

        await configuracionesProvider.getProvinciasByNombre(dep);
        final provinciasCargadas = configuracionesProvider.provincias;

        /// PROVINCIA
        if (prov != null &&
            prov.trim().isNotEmpty &&
            provinciasCargadas.any((p) => p.provincia == prov)) {
          _provinciaDestiValue = prov;
          _provinciaDestiCtrl.text = prov;

          await configuracionesProvider.getDistritosByNombre(prov);
          final distritosCargados = configuracionesProvider.distritos;

          /// DISTRITO
          if (dist != null &&
              dist.trim().isNotEmpty &&
              distritosCargados.any((d) => d.distrito == dist)) {
            final distritoSeleccionado = distritosCargados.firstWhere(
              (d) => d.distrito == dist,
            );

            _distritoDestiId = distritoSeleccionado.idDistrito;
            _distritoDestiValue = dist;
            _distritoDestiCtrl.text = dist;
            _distritoDestiIdCalculo = _distritoDestiId;
          } else {
            _distritoDestiValue = null;
            _distritoDestiCtrl.clear();
          }
        } else {
          _provinciaDestiValue = null;
          _provinciaDestiCtrl.clear();
          configuracionesProvider.clearDistritos();
        }
      } else {
        _departamentoDestiValue = null;
        _departamentoDestiCtrl.clear();
        configuracionesProvider.clearProvincias();
        configuracionesProvider.clearDistritos();
      }

      _cargandoUbicacionDesti = false;

      /// DIRECCIONES
      final seen = <String>{};
      direccionesDesti = clienteDetalle.direcciones
          .where((d) => d.direccion.trim().isNotEmpty)
          .where((d) => seen.add(d.direccion.trim()))
          .map(
            (d) => Direccion(
              direccion: d.direccion.trim(),
              referencia: d.referencia?.trim(),
            ),
          )
          .toList();
    }
  }

  Widget _buildReceiverResults(CustomersProvider provider) {
    final results = provider.customerByDocument;

    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          'No se encontraron clientes',
          style: AppStyles.labelSmall.copyWith(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: results.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: Colors.grey.shade200),
      itemBuilder: (_, index) {
        final cliente = results[index];

        return InkWell(
          onTap: () => _selectReceiver(cliente),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cliente.nombres ?? '',
                  style: AppStyles.labelSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  cliente.nroDocumento ?? '',
                  style: AppStyles.labelSmall.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  final List<String> calculos = ['Por Peso','Por Dimensiones'];
  final Map<String, String> tiposEntregaLabel = {
    "Agencia - Docimicilio": "Agencia - Domicilio",
    "Docimicilio - Agencia": "Domicilio - Agencia",
    "Agencia - Agencia": "Agencia - Agencia",
    "Domicilio - Domicilio": "Domicilio - Domicilio",
  };

  // bool _movilidad = false;
  // bool _otros = false;
  int _currentStep = 0;

  // =======================
  // Controllers (mock '')
  // =======================
  // final _senderNameCtrl = TextEditingController(text: '');
  final _senderContactoCtrl = TextEditingController(text: '');
  final _senderPhoneCtrl = TextEditingController(text: '');
  
  final TextEditingController _dniRemiCtrl = TextEditingController();
  final TextEditingController _dniDestiCtrl = TextEditingController();
  final TextEditingController _empresaRemiCtrl = TextEditingController();
  final TextEditingController _empresaDestiCtrl = TextEditingController();
  final TextEditingController _direccionRemiCtrl = TextEditingController();
  final TextEditingController _direccionDestiCtrl = TextEditingController();
  final TextEditingController _distritoNombreRemiCtrl = TextEditingController();
  final TextEditingController _distritoNombreDestiCtrl = TextEditingController();

  // final _receiverNameCtrl = TextEditingController(text: '');
  final _receiverContactoCtrl = TextEditingController(text: '');
  final _receiverPhoneCtrl = TextEditingController(text: '');
  final _receiverObservacionCtrl = TextEditingController(text: '');
  final _receiverGuiaCtrl = TextEditingController(text: '');

  final _packageWeightCtrl = TextEditingController(text: '');
  final _cantidadCtrl = TextEditingController(text: '');

  final _priceCtrl = TextEditingController(text: '');
  bool _esPorDimensiones = false;
  bool _esDeposito = false;
  bool _esCredito = false;
  bool bloquearDropdown = false;
  bool bloquearDropdownDesti = false;
  bool _cargandoUbicacionRemi = false;
  bool _cargandoUbicacionDesti = false;
  
  bool _mostrarResultadosRemi = false;
  bool _clienteSeleccionado = false;
  late FocusNode _senderFocusNode;
  bool _bloquearBusqueda = false;

  bool _mostrarResultadosDesti = false;
  bool _clienteSeleccionadoDesti = false;
  late FocusNode _receiverFocusNode;
  bool _bloquearBusquedaDesti = false;

  final _dimensionesCtrl = TextEditingController(text: '');
  final _bancoCtrl = TextEditingController(text: '');
  final _nroOperacionCtrl = TextEditingController(text: '');
  final _diasCtrl = TextEditingController(text: '');

  final _fechaEntregaCtrl = TextEditingController(text: '');

  bool _isStep1Valid() {
    return
      _agenciaCtrl.text.isNotEmpty &&
      _tipoEnvioCtrl.text.isNotEmpty &&
      _tipoEntregaCtrl.text.isNotEmpty;
  }

  bool _isStep2Valid() {
    return
      _dniRemiCtrl.text.isNotEmpty &&
      _direccionRemiCtrl.text.isNotEmpty &&
      _planCtrl.text.isNotEmpty;
  }

  bool _isStep3Valid() {
    return
      _dniDestiCtrl.text.isNotEmpty &&
      _direccionDestiCtrl.text.isNotEmpty;
  }

  bool _isStep4Valid() {
    if (_packageWeightCtrl.text.isEmpty || _priceCtrl.text.isEmpty) {
      return false;
    }

    if (_esCredito) {
      return _diasCtrl.text.isNotEmpty;
    }

    if (_esDeposito) {
      return _bancoCtrl.text.isNotEmpty &&
            _nroOperacionCtrl.text.isNotEmpty;
    }

    return true;
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _selectDate() async {
    DateTime initialDate;
    if (_fechaEntregaCtrl.text.isNotEmpty) {
      initialDate = DateFormat('dd/MM/yyyy').parse(_fechaEntregaCtrl.text);
    } else {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _fechaEntregaCtrl.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  String get fechaEntregaFormateada {
    if (_fechaEntregaCtrl.text.isEmpty) return '';

    final fecha = DateFormat('dd/MM/yyyy').parse(_fechaEntregaCtrl.text);
    return DateFormat('yyyy-MM-dd').format(fecha);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StepIndicator(currentStep: _currentStep),

        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _stepGeneral(),
              _stepSender(),
              _stepReceiver(),
              _stepPackage(),
              _stepSummary(),
            ],
          ),
        ),

        _navigationButtons(),
        const SizedBox(height: AppSpacing.md)
      ],
    );
  }

  // =======================
  // PASO 1 - GENERAL
  // =======================
  Widget _stepGeneral() {
    final sucursalesProvider = Provider.of<SucursalesProvider>(context, listen: true);
    final configuracionesProvider = Provider.of<ConfiguracionesProvider>(context, listen: true);

    final sucursales = sucursalesProvider.sucursales;
    final tiposEnvio = configuracionesProvider.tiposEnvio;

    return _StepContainer(
      title: 'Datos Generales',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Fecha Entrega:',
                style: AppStyles.inputLabel,
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _fechaEntregaCtrl.text.isEmpty
                              ? DateFormat('dd/MM/yyyy').format(_fechaActual)
                              : _fechaEntregaCtrl.text,
                          style: AppStyles.labelSmall,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: _selectDate,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.lg,),

          Text('Agencia', style: AppStyles.inputLabel),
          AppDropdownbuttonformfield2(
            controller: _agenciaCtrl,
            options: sucursales.map((e) => e.nombre).toList(),
            onChanged: (value) {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final idAgenciaOrigen = authProvider.session!.idSucursal;
              final agenciaOrigen = sucursales
                  .firstWhere((s) => s.id == idAgenciaOrigen)
                  .nombre;

              _direccionAgenciaOrigen = sucursales
                  .firstWhere((s) => s.id == idAgenciaOrigen)
                  .direccion;
              _distritoNombreAgenciaOrigen = sucursales
                  .firstWhere((s) => s.id == idAgenciaOrigen)
                  .distritoNombre;

              setState(() {
                _agenciaCtrl.text = value ?? '';
                _zonaCtrl.text =
                    value == agenciaOrigen ? 'Local' : 'Nacional';
              });
            },
          ),

          Text('Zona', style: AppStyles.inputLabel),
          AppTextField(
            controller: _zonaCtrl,
            enabled: false,
          ),

          Text('Tipo Envío', style: AppStyles.inputLabel),
          AppDropdownbuttonformfield2(
            controller: _tipoEnvioCtrl,
            options: tiposEnvio.map((e) => e.tipoEnvio).toList(), 
            onChanged: (value){
              setState(() {
                _tipoEnvioCtrl.text = value ?? '';
              });
            }
          ),
          
          Text('Tipo Entrega', style: AppStyles.inputLabel),
          AppDropdownbuttonformfield2(
            controller: _tipoEntregaCtrl,
            options: tiposEntregaLabel.values.toList(),
            enabled: _agenciaCtrl.text.isNotEmpty,
            onChanged: (labelSeleccionado) {
              final valorReal = tiposEntregaLabel.entries
                  .firstWhere((e) => e.value == labelSeleccionado)
                  .key;
                  
              _idAgenciaDestiCtrl = sucursales
                .firstWhere((s) => s.nombre == _agenciaCtrl.text)
                .id;

              if(valorReal == "Agencia - Docimicilio"){
                tipoEntrega = 1;
                _direccionRemiCtrl.text = _direccionAgenciaOrigen!;
                _distritoNombreRemiCtrl.text = _distritoNombreAgenciaOrigen!;
                _direccionDestiCtrl.text = "";
                _distritoNombreDestiCtrl.text = "";

              } if(valorReal == "Docimicilio - Agencia"){
                tipoEntrega = 2;
                _direccionDestiCtrl.text = sucursales
                  .firstWhere((s) => s.nombre == _agenciaCtrl.text)
                  .direccion;
                _distritoNombreDestiCtrl.text = sucursales
                  .firstWhere((s) => s.nombre == _agenciaCtrl.text)
                  .distritoNombre!;
                _distritoDestiIdCalculo = sucursales
                  .firstWhere((s) => s.nombre == _agenciaCtrl.text)
                  .idDistrito!;
                _direccionRemiCtrl.text = "";
                _distritoNombreRemiCtrl.text = "";

              } if(valorReal == "Agencia - Agencia"){
                tipoEntrega = 3;
                _direccionRemiCtrl.text = _direccionAgenciaOrigen!;
                _distritoNombreRemiCtrl.text = _distritoNombreAgenciaOrigen!;
                _direccionDestiCtrl.text = sucursales
                  .firstWhere((s) => s.nombre == _agenciaCtrl.text)
                  .direccion;
                _distritoNombreDestiCtrl.text = sucursales
                  .firstWhere((s) => s.nombre == _agenciaCtrl.text)
                  .distritoNombre!;
                _distritoDestiIdCalculo = sucursales
                  .firstWhere((s) => s.nombre == _agenciaCtrl.text)
                  .idDistrito!;

              } if(valorReal == "Domicilio - Domicilio"){
                tipoEntrega = 4;
                _direccionRemiCtrl.text = "";
                _distritoNombreRemiCtrl.text = "";
                _direccionDestiCtrl.text = "";
                _distritoNombreDestiCtrl.text = "";
              }
              
              setState(() {
                _tipoEntregaCtrl.text = labelSeleccionado ?? '';
              });

              _tipoEntregaReal = valorReal;
            },
          ),
        ],
      ),
    );
  }

  // =======================
  // PASO 2 - REMITENTE
  // =======================
  Widget _stepSender() {
    final customersProvider = Provider.of<CustomersProvider>(context, listen: true);
    final configuracionesProvider = Provider.of<ConfiguracionesProvider>(context, listen: true);

    final departamentos = configuracionesProvider.departamentos;
    final provincias = configuracionesProvider.provincias;
    final distritos = configuracionesProvider.distritos;
    final planes = configuracionesProvider.planes;
    final customers = customersProvider.customersType;

    return _StepContainer(
      title: 'Datos del remitente',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg,),
          Text('Remitente', style: AppStyles.inputLabel),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  padding: EdgeInsets.only(bottom: 1),
                  controller: _dniRemiCtrl,
                  focusNode: _senderFocusNode,
                  hintText: 'Buscar por DNI o nombre',
                  onTap: () {
                    if (_clienteSeleccionado) {
                      setState(() {
                        _clienteSeleccionado = false;
                        _bloquearBusqueda = false;
                      });
                    }
                  },
                  suffixIcon: _dniRemiCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          onPressed: () {
                            _dniRemiCtrl.clear();
                            setState(() {
                              _mostrarResultadosRemi = false;
                              _clienteSeleccionado = false;
                              _bloquearBusqueda = false;
                            });
                          },
                        )
                      : null,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () async {
                  final dniRegistrado = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NewCustomerScreen(esAtajo: true),
                    ),
                  );

                  if (dniRegistrado != null && dniRegistrado.isNotEmpty) {
                    _dniRemiCtrl.text = dniRegistrado;
                    // buscar automaticamente
                    _onSenderSearchChanged();
                    // asegurar foco
                    _senderFocusNode.requestFocus();
                  }
                },
              )
            ],
          ),
          if (_mostrarResultadosRemi && !_clienteSeleccionado)
          Container(
            constraints: const BoxConstraints(maxHeight: 180),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: Colors.grey.shade300),
                right: BorderSide(color: Colors.grey.shade300),
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildSenderResults(customersProvider),
          ),

          const SizedBox(height: AppSpacing.xl),

          Text('Empresa', style: AppStyles.inputLabel,),
          AppTextField(controller: _empresaRemiCtrl),

          Text('Tipo Cliente', style: AppStyles.inputLabel),
          AppDropdownbuttonformfield2(
            controller: _tipoClienteCtrl,
            value: _tipoClienteRemiValue, 
            options: customers.map((e) => e.tipoCliente).toList(), 
            onChanged: (value){
              setState(() {
                _tipoClienteCtrl.text = value ?? '';
              });
            }
          ),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Teléfono', style: AppStyles.inputLabel,),
                    AppTextField(
                      controller: _senderPhoneCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.md),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contacto', style: AppStyles.inputLabel,),
                    AppTextField(controller: _senderContactoCtrl),
                  ],
                ),
              ),
            ],
          ),

          Text('Plan', style: AppStyles.inputLabel),
          AppDropdownbuttonformfield(
            controller: _planCtrl,
            value: _planRemiValue,
            options: planes.map((e) => e.plan).toList(),
            onChanged: (value) {
              setState(() {
                _planRemiValue = value;
                _planCtrl.text = value ?? '';

                final planSeleccionado = planes.firstWhere(
                  (p) => p.plan == value,
                );
                _planId = planSeleccionado.idPlan;
              });
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('UBICACIONES', style: AppStyles.subtitleBlueSubrayado),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          if(tipoEntrega == 4 || tipoEntrega == 2)
          Row(
            children: [
              Expanded(
                child: AppDropdownbuttonformfield2(
                  padding: const EdgeInsets.only(bottom: 30, top: 10),
                  label: 'Direcciones',
                  enabled: !bloquearDropdown,
                  value: _direccionRemiSeleccionada?.direccion,
                  options: direccionesRemi!
                      .map((e) => e.direccion)
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    final seleccion = direccionesRemi!
                        .firstWhere((d) => d.direccion == value);

                    setState(() {
                      _direccionRemiSeleccionada = seleccion;
                      bloquearDropdown = false;
                    });

                    _direccionRemiCtrl.text = seleccion.direccion;
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    bloquearDropdown = true;
                    _direccionRemiSeleccionada = null;
                  });

                  _direccionRemiCtrl.clear();
                },
                onDoubleTap: () {
                  setState(() {
                    bloquearDropdown = false;
                    _direccionRemiSeleccionada = null;
                  });

                  _direccionRemiCtrl.clear();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),

          if(bloquearDropdown == true)
          const SizedBox(height: 10),
          if(tipoEntrega == 3 || tipoEntrega == 1 || (tipoEntrega == 2 && bloquearDropdown == true) || (tipoEntrega == 4 && bloquearDropdown == true))
          Text('Dirección', style: AppStyles.inputLabel,),
          if(tipoEntrega == 3 || tipoEntrega == 1 || (tipoEntrega == 2 && bloquearDropdown == true) || (tipoEntrega == 4 && bloquearDropdown == true))
          AppTextField(controller: _direccionRemiCtrl, hintText: 'Nueva dirección'),

          if(tipoEntrega == 3 || tipoEntrega == 1)
          Text('Distrito', style: AppStyles.inputLabel,),
          if(tipoEntrega == 3 || tipoEntrega == 1)
          AppTextField(controller: _distritoNombreRemiCtrl),          
          
          if(tipoEntrega == 4 || tipoEntrega == 2)
          Text('Departamento', style: AppStyles.inputLabel),
          if(tipoEntrega == 4 || tipoEntrega == 2)
          AppDropdownbuttonformfield(
            controller: _departamentoRemiCtrl,
            value: _departamentoRemiValue,
            options: departamentos.map((e) => e.departamento).toList(), 
            onChanged: (value) {
              if (value == _departamentoRemiValue) return;

              setState(() {
                _departamentoRemiValue = value;
                _departamentoRemiCtrl.text = value ?? '';
              });

              if (_cargandoUbicacionRemi) return;

              _provinciaRemiValue = null;
              _distritoRemiValue = null;
              _provinciaRemiCtrl.clear();
              _distritoRemiCtrl.clear();

              final departamentoSeleccionado = departamentos.firstWhere(
                (d) => d.departamento == value,
              );

              configuracionesProvider.clearProvincias();
              configuracionesProvider.clearDistritos();

              configuracionesProvider.getProvincias(
                departamentoSeleccionado.idDepartamento,
              );
            },
            hintText: 'Departamento'
          ),
          
          if(tipoEntrega == 4 || tipoEntrega == 2)
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Provincia', style: AppStyles.inputLabel),
                    AppDropdownbuttonformfield(
                      controller: _provinciaRemiCtrl,
                      value: _provinciaRemiValue, 
                      options: provincias.map((e) => e.provincia).toList(), 
                      onChanged: provincias.isEmpty
                        ? null
                        : (value) {
                            setState(() {
                              _provinciaRemiValue = value;
                              _provinciaRemiCtrl.text = value ?? '';
                            });
                    
                            if (_cargandoUbicacionRemi) return;
                    
                            _distritoRemiValue = null;
                            _distritoRemiCtrl.clear();
                    
                            final provinciaSeleccionada = provincias.firstWhere(
                              (p) => p.provincia == value,
                            );
                    
                            configuracionesProvider.clearDistritos();
                            configuracionesProvider.getDistritos(
                              provinciaSeleccionada.idProvincia,
                            );
                          },
                      hintText: 'Provincia',
                    ),
                  ],
                )
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Distrito', style: AppStyles.inputLabel),
                    AppDropdownbuttonformfield(
                      controller: _distritoRemiCtrl, 
                      value: _distritoRemiValue,
                      options: distritos.map((e) => e.distrito).toList(), 
                      onChanged: distritos.isEmpty
                        ? null
                        : (value) {
                            setState(() {
                              _distritoRemiValue = value;
                              _distritoRemiCtrl.text = value ?? '';
                            });
                    
                            final distritoSeleccionado = distritos.firstWhere(
                              (p) => p.distrito == _distritoRemiValue,
                            );
                            _distritoRemiId = distritoSeleccionado.idDistrito;
                          },
                      hintText: 'Distrito',
                    ),
                  ],
                )
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =======================
  // PASO 3 - DESTINATARIO
  // =======================
  Widget _stepReceiver() {
    final customersProvider = Provider.of<CustomersProvider>(context, listen: true);
    final configuracionesProvider = Provider.of<ConfiguracionesProvider>(context, listen: true);

    final departamentos = configuracionesProvider.departamentos;
    final provincias = configuracionesProvider.provincias;
    final distritos = configuracionesProvider.distritos;
    final customers = customersProvider.customersType;

    return _StepContainer(
      title: 'Datos del destinatario',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg,),
          Text('Destinatario', style: AppStyles.inputLabel,),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  padding: EdgeInsets.only(bottom: 1),
                  controller: _dniDestiCtrl,
                  focusNode: _receiverFocusNode,
                  hintText: 'Buscar por DNI o nombre',
                  onTap: () {
                    if (_clienteSeleccionadoDesti) {
                      setState(() {
                        _clienteSeleccionadoDesti = false;
                        _bloquearBusquedaDesti = false;
                      });
                    }
                  },
                  suffixIcon: _dniDestiCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          onPressed: () {
                            _dniDestiCtrl.clear();
                            setState(() {
                              _mostrarResultadosDesti = false;
                              _clienteSeleccionadoDesti = false;
                              _bloquearBusquedaDesti = false;
                            });
                          },
                        )
                      : null,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () async {
                  final dniRegistrado = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NewCustomerScreen(esAtajo: true),
                    ),
                  );

                  if (dniRegistrado != null && dniRegistrado.isNotEmpty) {
                    _dniDestiCtrl.text = dniRegistrado;
                    _onSenderSearchChanged();
                    _senderFocusNode.requestFocus();
                  }
                },
              )
            ],
          ),
          if (_mostrarResultadosDesti && !_clienteSeleccionadoDesti)
          Container(
            constraints: const BoxConstraints(maxHeight: 180),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: Colors.grey.shade300),
                right: BorderSide(color: Colors.grey.shade300),
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildReceiverResults(customersProvider),
          ),

          const SizedBox(height: AppSpacing.xl),
          
          Text('Empresa', style: AppStyles.inputLabel,),
          AppTextField(controller: _empresaDestiCtrl),
          Text('Tipo Cliente', style: AppStyles.inputLabel),
          AppDropdownbuttonformfield2(
            controller: _tipoClienteCtrl,
            value: _tipoClienteDestiValue,
            options: customers.map((e) => e.tipoCliente).toList(), 
            onChanged: (value){
              setState(() {
                _tipoClienteCtrl.text = value ?? '';
              });
            }
          ),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Teléfono', style: AppStyles.inputLabel,),
                    AppTextField(
                      controller: _receiverPhoneCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contacto', style: AppStyles.inputLabel,),
                    AppTextField(controller: _receiverContactoCtrl),
                  ],
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('UBICACIONES', style: AppStyles.subtitleBlueSubrayado),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          if(tipoEntrega == 4 || tipoEntrega == 1)
          Row(
            children: [
              Expanded(
                child: AppDropdownbuttonformfield2(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  label: 'Direcciones',
                  enabled: !bloquearDropdownDesti,
                  value: _direccionDestiSeleccionada?.direccion,
                  options: direccionesDesti!
                      .map((e) => e.direccion)
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    final seleccion = direccionesDesti!
                        .firstWhere((d) => d.direccion == value);

                    setState(() {
                      _direccionDestiSeleccionada = seleccion;
                      bloquearDropdownDesti = false;
                    });

                    _direccionDestiCtrl.text = seleccion.direccion;
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    bloquearDropdownDesti = true;
                    _direccionDestiSeleccionada = null;
                  });

                  _direccionDestiCtrl.clear();
                },
                onDoubleTap: () {
                  setState(() {
                    bloquearDropdownDesti = false;
                    _direccionDestiSeleccionada = null;
                  });

                  _direccionDestiCtrl.clear();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),

          if(bloquearDropdownDesti == true)
          const SizedBox(height: 10),
          if(tipoEntrega == 3 || tipoEntrega == 2 || (tipoEntrega == 1 && bloquearDropdownDesti == true) || (tipoEntrega == 4 && bloquearDropdownDesti == true))
          Text('Dirección', style: AppStyles.inputLabel,),
          if(tipoEntrega == 3 || tipoEntrega == 2 || (tipoEntrega == 1 && bloquearDropdownDesti == true) || (tipoEntrega == 4 && bloquearDropdownDesti == true))
          AppTextField(controller: _direccionDestiCtrl, hintText: 'Nueva dirección'),

          if(tipoEntrega == 3 || tipoEntrega == 2)
          Text('Distrito', style: AppStyles.inputLabel,),
          if(tipoEntrega == 3 || tipoEntrega == 2)
          AppTextField(controller: _distritoNombreDestiCtrl),

          if(tipoEntrega == 4 || tipoEntrega == 1)
          AppDropdownbuttonformfield(
            controller: _departamentoDestiCtrl,
            value: _departamentoDestiValue, 
            options: departamentos.map((e) => e.departamento).toList(), 
            onChanged: (value) {
              if (value == _departamentoDestiValue) return;

              setState(() {
                _departamentoDestiValue = value;
                _departamentoDestiCtrl.text = value ?? '';
              });

              if (_cargandoUbicacionDesti) return;

              _provinciaDestiValue = null;
              _distritoDestiValue = null;
              _provinciaDestiCtrl.clear();
              _distritoDestiCtrl.clear();

              final departamentoSeleccionado = departamentos.firstWhere(
                (d) => d.departamento == value,
              );

              configuracionesProvider.clearProvincias();
              configuracionesProvider.clearDistritos();

              configuracionesProvider.getProvincias(
                departamentoSeleccionado.idDepartamento,
              );
            },
            hintText: 'Departamento'
          ),

          if(tipoEntrega == 4 || tipoEntrega == 1)
          Row(
            children: [
              Expanded(
                child: AppDropdownbuttonformfield(
                  controller: _provinciaDestiCtrl,
                  value: _provinciaDestiValue, 
                  options: provincias.map((e) => e.provincia).toList(), 
                  onChanged: provincias.isEmpty
                    ? null
                    : (value) {
                        setState(() {
                          _provinciaDestiValue = value;
                          _provinciaDestiCtrl.text = value ?? '';
                        });

                        if (_cargandoUbicacionDesti) return;

                        _distritoDestiValue = null;
                        _distritoDestiCtrl.clear();

                        final provinciaSeleccionada = provincias.firstWhere(
                          (p) => p.provincia == value,
                        );

                        configuracionesProvider.clearDistritos();
                        configuracionesProvider.getDistritos(
                          provinciaSeleccionada.idProvincia,
                        );
                      },
                  hintText: 'Provincia',
                )
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppDropdownbuttonformfield(
                  controller: _distritoDestiCtrl,
                  value: _distritoDestiValue, 
                  options: distritos.map((e) => e.distrito).toList(), 
                  onChanged: distritos.isEmpty
                    ? null
                    : (value) {
                        setState(() {
                          _distritoDestiValue = value;
                          _distritoDestiCtrl.text = value ?? '';
                        });

                        final distritoSeleccionado = distritos.firstWhere(
                          (p) => p.distrito == _distritoDestiValue,
                        );

                        _distritoDestiIdCalculo = distritoSeleccionado.idDistrito;
                        _distritoDestiId = distritoSeleccionado.idDistrito;
                      },
                  hintText: 'Distrito',
                )
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('ADICIONAL', style: AppStyles.subtitleBlueSubrayado),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          Text('Observaciones', style: AppStyles.inputLabel,),
          AppTextField(controller: _receiverObservacionCtrl),
          
          Text('Guía de remitente', style: AppStyles.inputLabel,),
          AppTextField(controller: _receiverGuiaCtrl),
        ],
      ),
    );
  }

  // =======================
  // PASO 4 - PAQUETE
  // =======================
  Widget _stepPackage() {
    final configuracionesProvider = Provider.of<ConfiguracionesProvider>(context, listen: true);
    final customersProvider = Provider.of<CustomersProvider>(context, listen: true);
    final tiposPago = configuracionesProvider.tiposPago;
    final customerDesti = customersProvider.customerByDocument;

    void _marcarPrecioComoDesactualizado() {
      if (_precioCalculado) {
        setState(() {
          _precioCalculado = false;
        });
      }
    }

    void _calcularPesoPorDimensiones(String value) {
      final partes = value.toLowerCase().split('x');

      if (partes.length != 3) {
        _packageWeightCtrl.text = '0';
        return;
      }

      final d1 = double.tryParse(partes[0]) ?? 0;
      final d2 = double.tryParse(partes[1]) ?? 0;
      final d3 = double.tryParse(partes[2]) ?? 0;

      final peso = (d1 * d2 * d3) / 6000;

      _packageWeightCtrl.text = peso.toStringAsFixed(2);
    }

    Future<void> _calcularPrecio() async {
      setState(() {
        _mensajeError = null;
      });

      double? parsePeso(String value) {
        return double.tryParse(
          value.replaceAll(',', '.').trim(),
        );
      }
      final peso = parsePeso(_packageWeightCtrl.text);
      
      if (peso == null) {
        setState(() {
          _mensajeError = 'Ingrese un peso válido';
        });
        return;
      }

      final error = validarPesoPorTipoEnvio(
        tipoEnvio: _tipoEnvioCtrl.text,
        pesoKg: peso,
      );

      if (error != null) {
        setState(() {
          _mensajeError = error;
        });
        return;
      }


      if (_planId == null) {
        _mensajeError = 'Seleccione un plan';
      } else if (_tipoEnvioCtrl.text.isEmpty) {
        _mensajeError = 'Seleccione el tipo de envío';
      } else if (_distritoDestiIdCalculo == null) {
        _mensajeError = 'Seleccione el distrito destino';
      } else if (_tipoEntregaCtrl.text.isEmpty) {
        _mensajeError = 'Seleccione el tipo de entrega';
      } else if (customerDesti.isEmpty) {
        _mensajeError = 'Seleccione un cliente destino';
      } else if (_packageWeightCtrl.text.isEmpty ||
          double.tryParse(_packageWeightCtrl.text.replaceAll(',', '.')) == null) {
        _mensajeError = 'Ingrese un peso válido';
      }

      if (_mensajeError != null) {
        setState(() {});
        return;
      }

      final provider = Provider.of<EncomiendasProvider>(context, listen: false);
      final cliente = customerDesti.first;
      
      await provider.calcularPrecio(
        peso,
        cliente.id!,
        _distritoDestiIdCalculo!,
        _planId!,
        _tipoEnvioCtrl.text,
        _tipoEntregaReal ?? '',
      );

      final precio = provider.precioCalculado?.precio;

      if (precio != null) {
        setState(() {
          _priceCtrl.text = precio.toStringAsFixed(2);
          _precioCalculado = true;
        });
      }
    }

    return _StepContainer(
      title: 'Datos del paquete',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg,),
          Text('Calcular precio', style: AppStyles.inputLabel),
          AppDropdownbuttonformfield(
            controller: _tipoCalculoCtrl,
            options: calculos,
            hintText: '0x0x0',
            onChanged: (value) {
              setState(() {
                _esPorDimensiones = value == 'Por Dimensiones';
                _tipoCalculoCtrl.text = value ?? '';

                if (_esPorDimensiones) {
                  _packageWeightCtrl.text = '0';
                } else {
                  _dimensionesCtrl.clear();
                  _packageWeightCtrl.clear();
                }
              });

              _marcarPrecioComoDesactualizado();
            },
          ),

          if (_esPorDimensiones) ...[
            Text('Dimensiones (cm)', style: AppStyles.inputLabel),
            const SizedBox(height: AppSpacing.lg,),
            TextField(
              controller: _dimensionesCtrl,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                _calcularPesoPorDimensiones(value);
                _marcarPrecioComoDesactualizado();
              },
              decoration: InputDecoration(
                hintText: '0x0x0',
                hintStyle: AppStyles.labelHintText
              ),
              style: AppStyles.label,
            ),
            const SizedBox(height: AppSpacing.lg,),
          ],

          Text('Peso (kg)', style: AppStyles.inputLabel),
          TextField(
            controller: _packageWeightCtrl,
            enabled: !_esPorDimensiones || _tipoCalculoCtrl.text.isNotEmpty,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d*[.]?\d*$'),
              ),
            ],
            onChanged: (_) {
              if (!_esPorDimensiones) {
                _marcarPrecioComoDesactualizado();
              }
            },
          ),

          if (_mensajeError != null) ...[
          const SizedBox(height: 8),
          Text(
            _mensajeError!,
            style: const TextStyle(color: Colors.red),
          ),
        ],

        const SizedBox(height: 12),

        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: _precioCalculado ? Colors.green : Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: _calcularPrecio,
          child: const Text('Calcular Precio'),
        ),

          const SizedBox(height: AppSpacing.lg),

          Text('Tipo pago', style: AppStyles.inputLabel),
          AppDropdownbuttonformfield(
            controller: _tipoPagoCtrl,
            value: _tipoPagoValueDesti,
            options: tiposPago.map((e) => e.tipoPago).toList(), 
            onChanged: _onTipoPagoChanged,
            hintText: 'Seleccione'
          ),

          if (_esDeposito) ...[
            Text('Banco (depósito)', style: AppStyles.inputLabel),
            TextField(
              controller: _bancoCtrl,
              keyboardType: TextInputType.text,
              onChanged: (value) {
              },
              style: AppStyles.label,
            ),
            const SizedBox(height: AppSpacing.lg),

            Text('Nro Operación (depósito)', style: AppStyles.inputLabel),
            TextField(
              controller: _nroOperacionCtrl,
              keyboardType: TextInputType.number,
              onChanged: (value) {
              },
              style: AppStyles.label,
            ),
          ],

          if (_esCredito) ...[
            Text('Dias (crédito)', style: AppStyles.inputLabel),
            TextField(
              controller: _diasCtrl,
              keyboardType: TextInputType.number,
              onChanged: (value) {
              },
              style: AppStyles.label,
            ),
          ],
          
          const SizedBox(height: AppSpacing.lg),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cantidad', style: AppStyles.inputLabel),
                    TextField(
                      controller: _cantidadCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (_) => null,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Text('Precio', style: AppStyles.inputLabel),
          AppTextField(controller: _priceCtrl),
        ],
      ),
    );
  }

  // =======================
  // PASO 5 - RESUMEN
  // =======================
  Widget _stepSummary() {
    return _StepContainer(
      title: 'Resumen de la encomienda',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summaryItem('Remitente', _empresaRemiCtrl.text),
          _summaryItem('Contacto', _senderPhoneCtrl.text),
          _summaryItem(
            'Origen',
            [
              _departamentoRemiCtrl.text,
              _provinciaRemiCtrl.text,
              _distritoRemiCtrl.text,
            ].where((e) => e.isNotEmpty).join(' - '),
          ),

          const Divider(height: 24),

          _summaryItem('Destinatario', _empresaDestiCtrl.text),
          _summaryItem('Contacto', _receiverPhoneCtrl.text),
          _summaryItem(
            'Destino',
            [
              _departamentoDestiCtrl.text,
              _provinciaDestiCtrl.text,
              _distritoDestiCtrl.text,
            ].where((e) => e.isNotEmpty).join(' - '),
          ),

          const Divider(height: 24),

          _summaryItem('Tipo de entrega', _tipoEntregaLabel()),
          _summaryItem('Cantidad', _cantidadCtrl.text),
          _summaryItem('Peso', '${_packageWeightCtrl.text} kg'),
          _summaryItem('Precio', 'S/ ${_priceCtrl.text}'),
        ],
      ),
    );
  }
  
  String _tipoEntregaLabel() {
    switch (tipoEntrega) {
      case 1:
        return 'Agencia → Domicilio';
      case 2:
        return 'Domicilio → Agencia';
      case 4:
        return 'Domicilio → Domicilio';
      default:
        return '-';
    }
  }

  // =======================
  // BOTONES
  // =======================
  Widget _navigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                ),
                onPressed: _prevStep,
                child: const Text('Anterior'),
              ),
            ),

          if (_currentStep > 0) const SizedBox(width: 12),

          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: _currentStep == 4
                  ? _submit
                  : (_currentStep == 0 && !_isStep1Valid()) || (_currentStep == 1 && !_isStep2Valid()) || (_currentStep == 2 && !_isStep3Valid()) || (_currentStep == 3 && !_isStep4Valid())
                      ? null
                      : _nextStep,
              child: Text(
                _currentStep == 4
                    ? widget.isEditing
                        ? 'Actualizar'
                        : 'Registrar'
                    : 'Siguiente',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    final encomiendasProvider = Provider.of<EncomiendasProvider>(context, listen: false);
    final newEncomienda = Encomienda(
      tipoEntrega: _tipoEntregaCtrl.text,
      tipoEnvio: _tipoEnvioCtrl.text,
      idAgenciaDestino: _idAgenciaDestiCtrl,
      idRemitente: _idClienteRemi,
      remitenteDocumento: _dniRemiCtrl.text, 
      remitenteDireccion: _direccionRemiCtrl.text,
      remitenteContacto: _senderContactoCtrl.text,
      remitenteCelular: _senderPhoneCtrl.text,
      remitenteIdDistritoDomicilio: _distritoRemiId,
      idDestinatario: _idClienteDesti,
      destinatarioDocumento: _dniDestiCtrl.text,
      destinatarioContacto: _receiverContactoCtrl.text,
      destinatarioCelular: _receiverPhoneCtrl.text,
      destinatarioDireccion: _direccionDestiCtrl.text,
      destinatarioIdDistritoDomicilio: _distritoDestiId,
      fechaEntrega: fechaEntregaFormateada,
      costoTotal: _priceCtrl.text,
      cantidad: _cantidadCtrl.text,  
      kg: _packageWeightCtrl.text,
      observacion: _receiverObservacionCtrl.text,
      tipoPago: _tipoPagoCtrl.text,
      guiaRemitente: _receiverGuiaCtrl.text,
      banco: _bancoCtrl.text,
      nroOperacion: _nroOperacionCtrl.text
    );

    try {
      await encomiendasProvider.createEncomienda(newEncomienda);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Encomienda registrada con éxito'),
          duration: Duration(seconds: 3),
        ),
      );

      debugPrint('Encomienda enviada');
      // _formKey.currentState?.reset();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar encomienda'),
          duration: Duration(seconds: 3),
        ),
      );
      debugPrint('Error: $e');
    }
  }

  // =======================
  // WIDGETS AUX
  // =======================

  Widget _summaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: AppStyles.labelSmall.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value.isNotEmpty ? value : '-',
              textAlign: TextAlign.right,
              style: AppStyles.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}

// =======================
// COMPONENTES REUTILIZABLES
// =======================

class _StepContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _StepContainer({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;

  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          return CircleAvatar(
            radius: 14,
            backgroundColor:
                currentStep >= index ? AppColors.primary : AppColors.secondary,
            child: Text('${index + 1}',
                style: const TextStyle(color: Colors.white)),
          );
        }),
      ),
    );
  }
}
