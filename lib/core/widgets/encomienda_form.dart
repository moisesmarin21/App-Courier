import 'package:courier/core/constants/app_dropdownButtonFormField.dart';
import 'package:courier/core/constants/app_textField.dart';
import 'package:courier/core/constants/colors.dart';
import 'package:courier/core/constants/spacing.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:courier/models/encomienda.dart';
import 'package:courier/providers/auth_provider.dart';
import 'package:courier/providers/configuraciones_provider.dart';
import 'package:courier/providers/customer_provider.dart';
import 'package:courier/providers/encomiendas_provider.dart';
import 'package:courier/providers/sucursales_provider.dart';
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
  String? _departamentoDestiValue;
  String? _provinciaDestiValue;
  String? _distritoDestiValue;
  String? _tipoEntregaReal;

  int? _departamentoRemiId;
  int? _provinciaRemiId;
  int? _distritoRemiId;
  int? _departamentoDestiId;
  int? _provinciaDestiId;
  int? _distritoDestiId;
  int? _planId;

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

    _departamentoRemiValue = null;
    _provinciaRemiValue = null;
    _distritoRemiValue = null;
    _departamentoDestiValue = null;
    _provinciaDestiValue = null;
    _distritoDestiValue = null;

    _cantidadCtrl.text = "1";
  }

  @override
  void dispose() {
    _agenciaCtrl.dispose();
    super.dispose();
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
  final _senderNameCtrl = TextEditingController(text: '');
  final _senderPhoneCtrl = TextEditingController(text: '');
  
  final TextEditingController _dniRemiCtrl = TextEditingController();
  final TextEditingController _dniDestiCtrl = TextEditingController();
  final TextEditingController _empresaRemiCtrl = TextEditingController();
  final TextEditingController _empresaDestiCtrl = TextEditingController();

  final _receiverNameCtrl = TextEditingController(text: '');
  final _receiverPhoneCtrl = TextEditingController(text: '');
  final _receiverObservacionCtrl = TextEditingController(text: '');
  final _receiverGuiaCtrl = TextEditingController(text: '');

  final _packageWeightCtrl = TextEditingController(text: '');
  final _cantidadCtrl = TextEditingController(text: '');

  final _priceCtrl = TextEditingController(text: '');
  bool _esPorDimensiones = false;
  bool _esDeposito = false;
  bool _esCredito = false;
  final _dimensionesCtrl = TextEditingController(text: '');
  final _bancoCtrl = TextEditingController(text: '');
  final _nroOperacionCtrl = TextEditingController(text: '');
  final _diasCtrl = TextEditingController(text: '');

  final _fechaEntregaCtrl = TextEditingController(text: '');

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
      ],
    );
  }

  // =======================
  // PASO 1 - GENERAL
  // =======================
  Widget _stepGeneral() {
    final sucursalesProvider = Provider.of<SucursalesProvider>(context, listen: true);
    final customersProvider = Provider.of<CustomersProvider>(context, listen: true);
    final configuracionesProvider = Provider.of<ConfiguracionesProvider>(context, listen: true);

    final sucursales = sucursalesProvider.sucursales;
    final customers = customersProvider.customersType;
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
          AppDropdownbuttonformfield(
            controller: _agenciaCtrl,
            options: sucursales.map((e) => e.nombre).toList(),
            onChanged: (value) {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final idAgenciaOrigen = authProvider.session!.idSucursal;

              final agenciaOrigen = sucursales
                  .firstWhere((s) => s.id == idAgenciaOrigen)
                  .nombre;

              setState(() {
                _zonaCtrl.text =
                    value == agenciaOrigen ? 'Local' : 'Nacional';
              });
            },
          ),

          Text('Zona', style: AppStyles.inputLabel),
          TextField(
            controller: _zonaCtrl,
            enabled: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
            ),
            style: AppStyles.labelBlocked,
          ),

          const SizedBox(height: AppSpacing.lg,),

          Text('Tipo Envío', style: AppStyles.inputLabel),
          AppDropdownbuttonformfield(
            controller: _tipoEnvioCtrl, ///CAMBIAR
            options: tiposEnvio.map((e) => e.tipoEnvio).toList(), 
            onChanged: (value) => 0
          ),
          
          Text('Tipo Entrega', style: AppStyles.inputLabel),
          AppDropdownbuttonformfield(
            controller: _tipoEntregaCtrl,
            options: tiposEntregaLabel.values.toList(),
            onChanged: (labelSeleccionado) {
              final valorReal = tiposEntregaLabel.entries
                  .firstWhere((e) => e.value == labelSeleccionado)
                  .key;

              _tipoEntregaReal = valorReal;
            },
          ),

          Text('Tipo Cliente', style: AppStyles.inputLabel),
          AppDropdownbuttonformfield(
            controller: _tipoClienteCtrl, 
            options: customers.map((e) => e.tipoCliente).toList(), 
            onChanged: (value) => 0
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

    return _StepContainer(
      title: 'Datos del remitente',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg,),
          Text('Remitente', style: AppStyles.inputLabel),
          Row(
            children: [
              Expanded(flex: 9, child: AppTextField(controller: _dniRemiCtrl, hintText: 'DNI DEL REMITENTE')),
              Expanded(
                flex: 1, 
                child: IconButton(
                  onPressed: () async {
                    final nroDocumento = _dniRemiCtrl.text.trim();

                    if (nroDocumento.isEmpty) return;

                    await customersProvider.getCustomerByDocument(nroDocumento);

                    final cliente = customersProvider.customerByDocument;

                    if (cliente.isNotEmpty) {
                      _empresaRemiCtrl.text = cliente.first.nombres!;
                    }
                  },
                  icon: Icon(Icons.person)))
            ],
          ),

          Text('Empresa', style: AppStyles.inputLabel,),
          AppTextField(controller: _empresaRemiCtrl),

          Text('Dirección', style: AppStyles.inputLabel,),
          AppDropdownbuttonformfield(
            controller: _departamentoRemiCtrl,
            value: _departamentoRemiValue, 
            options: departamentos.map((e) => e.departamento).toList(), 
            onChanged: (value) {
              if (value == _departamentoRemiValue) return;

              setState(() {
                _departamentoRemiValue = value;
                _provinciaRemiValue = null;
                _distritoRemiValue = null;

                _departamentoRemiCtrl.text = value ?? '';
                _provinciaRemiCtrl.clear();
                _distritoRemiCtrl.clear();
              });

              final departamentoSeleccionado = departamentos.firstWhere(
                (d) => d.departamento == value,
              );
              _departamentoRemiId = departamentoSeleccionado.idDepartamento;

              configuracionesProvider.clearProvincias();
              configuracionesProvider.clearDistritos();

              configuracionesProvider.getProvincias(
                departamentoSeleccionado.idDepartamento,
              );
            },
            hintText: 'Departamento'
          ),
          Row(
            children: [
              Expanded(
                child: AppDropdownbuttonformfield(
                  controller: _provinciaRemiCtrl,
                  value: _provinciaRemiValue, 
                  options: provincias.map((e) => e.provincia).toList(), 
                  onChanged: provincias.isEmpty
                    ? null
                    : (value) {
                        setState(() {
                          _provinciaRemiValue = value;
                          _distritoRemiValue = null;

                          _provinciaRemiCtrl.text = value ?? '';
                          _distritoRemiCtrl.clear();
                        });

                        final provinciaSeleccionada = provincias.firstWhere(
                          (p) => p.provincia == value,
                        );
                        _provinciaRemiId = provinciaSeleccionada.idProvincia;

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
                          (p) => p.distrito == value,
                        );
                        _distritoRemiId = distritoSeleccionado.idDistrito;
                      },
                  hintText: 'Distrito',
                )
              ),
            ],
          ),

          Text('Contacto', style: AppStyles.inputLabel,),
          AppTextField(
            controller: _senderPhoneCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),

          // Text('Teléfono', style: AppStyles.inputLabel,),
          // AppTextField(controller: _senderPhoneCtrl),

          AppDropdownbuttonformfield(
            controller: _planCtrl, 
            label: 'Plan', 
            options: planes.map((e) => e.plan).toList(), 
            onChanged: (value) {
              final plan = planes.firstWhere(
                (p) => p.plan == value,
              );

              _planId = plan.idPlan;
            }, 
            hintText: 'Plan'
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

    return _StepContainer(
      title: 'Datos del destinatario',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg,),
          Text('Destinatario', style: AppStyles.inputLabel,),
          Row(
            children: [
              Expanded(flex: 9, child: AppTextField(controller: _dniDestiCtrl, hintText: 'DNI DEL DESTINATARIO')),
              Expanded(
                flex: 1, 
                child: IconButton(
                  onPressed: () async {
                    final nroDocumento = _dniDestiCtrl.text.trim();

                    if (nroDocumento.isEmpty) return;

                    await customersProvider.getCustomerByDocument(nroDocumento);

                    final cliente = customersProvider.customerByDocument;

                    if (cliente.isNotEmpty) {
                      _empresaDestiCtrl.text = cliente.first.nombres!;
                    }
                  },
                  icon: Icon(
                    Icons.person
                  )
                )
              )
            ],
          ),

          Text('Empresa', style: AppStyles.inputLabel,),
          AppTextField(controller: _empresaDestiCtrl),

          Text('Dirección', style: AppStyles.inputLabel,),
          AppDropdownbuttonformfield(
            controller: _departamentoDestiCtrl,
            value: _departamentoDestiValue, 
            options: departamentos.map((e) => e.departamento).toList(), 
            onChanged: (value) {
              if (value == _departamentoDestiValue) return;

              setState(() {
                _departamentoDestiValue = value;
                _provinciaDestiValue = null;
                _distritoDestiValue = null;

                _departamentoDestiCtrl.text = value ?? '';
                _provinciaDestiCtrl.clear();
                _distritoDestiCtrl.clear();
              });

              final departamentoSeleccionado = departamentos.firstWhere(
                (d) => d.departamento == value,
              );
              _departamentoDestiId = departamentoSeleccionado.idDepartamento;

              configuracionesProvider.clearProvincias();
              configuracionesProvider.clearDistritos();

              configuracionesProvider.getProvincias(
                departamentoSeleccionado.idDepartamento,
              );
            },
            hintText: 'Departamento'
          ),
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
                          _distritoDestiValue = null;

                          _provinciaDestiCtrl.text = value ?? '';
                          _distritoDestiCtrl.clear();
                        });

                        final provinciaSeleccionada = provincias.firstWhere(
                          (p) => p.provincia == value,
                        );
                        _provinciaDestiId = provinciaSeleccionada.idProvincia;

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
                          (p) => p.distrito == value,
                        );
                        _distritoDestiId = distritoSeleccionado.idDistrito;
                      },
                  hintText: 'Distrito',
                )
              ),
            ],
          ),

          Text('Contacto', style: AppStyles.inputLabel,),
          AppTextField(controller: _receiverPhoneCtrl),

          // Text('Teléfono', style: AppStyles.inputLabel,),
          // AppTextField(controller: _senderPhoneCtrl),

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

    Future<void> _intentarCalcularPrecio() async {
      if (_planId == null) return;
      if (_tipoEnvioCtrl.text.isEmpty) return;
      if (_tipoEntregaCtrl.text.isEmpty) return;
      if (customerDesti.isEmpty) return;
      
      // if (_tipoCalculoCtrl.text.isEmpty) return;
      if (_packageWeightCtrl.text.isEmpty ||
          double.tryParse(_packageWeightCtrl.text.replaceAll(',', '.')) == null) {
        return;
      }
      // if (_tipoPagoCtrl.text.isEmpty) return;
      // if (_cantidadCtrl.text.isEmpty) return;

      final encomiendasProvider = Provider.of<EncomiendasProvider>(context, listen: false);

      final peso = double.parse(
        _packageWeightCtrl.text.replaceAll(',', '.'),
      );

      final cliente = customerDesti.isNotEmpty ? customerDesti.first : null;
      // final idDistritoDestino = cliente != null ? cliente.idDistrito! : 0;
      final idDistritoDestino = _distritoDestiId ?? 0;
      final idClienteDestino = cliente != null ? cliente.id! : 0;
      final idPlan = _planId ?? 0;
      final tipoEnvio = _tipoEnvioCtrl.text;
      final tipoEntrega = _tipoEntregaReal ?? '';
      
      await encomiendasProvider.calcularPrecio(peso, idClienteDestino, idDistritoDestino, idPlan, tipoEnvio, tipoEntrega);

      final precio = encomiendasProvider.precioCalculado?.precio;

      if (precio != null) {
        _priceCtrl.text = precio.toStringAsFixed(2);
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
            options: calculos, // ['Por Peso', 'Por Dimensiones']
            hintText: 'Seleccione',
            onChanged: (value) {
              setState(() {
                _esPorDimensiones = value == 'Por Dimensiones';

                if (_esPorDimensiones) {
                  _dimensionesCtrl.text = '0x0x0';
                  _packageWeightCtrl.text = '0';
                } else {
                  _dimensionesCtrl.clear();
                  _packageWeightCtrl.clear();
                }
              });

              _intentarCalcularPrecio();
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
                _intentarCalcularPrecio();
              },
              style: AppStyles.label,
            ),
            const SizedBox(height: AppSpacing.lg,),
          ],

          Text('Peso (kg)', style: AppStyles.inputLabel),
          TextField(
            controller: _packageWeightCtrl,
            enabled: !_esPorDimensiones,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d*[.]?\d*$'),
              ),
            ],
            onChanged: (_) {
              if (!_esPorDimensiones) {
                _intentarCalcularPrecio();
              }
            },
          ),

          const SizedBox(height: AppSpacing.lg,),

          Text('Tipo pago', style: AppStyles.inputLabel),
          AppDropdownbuttonformfield(
            controller: _tipoPagoCtrl, 
            options: tiposPago.map((e) => e.tipoPago).toList(), 
            onChanged: (value) {
              setState(() {
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
                  _diasCtrl.text = '';
                } else {
                  _diasCtrl.clear();
                }
              });
            },
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
                      onChanged: (_) => _intentarCalcularPrecio(),
                    ),
                  ],
                ),
              ),
              // const SizedBox(width: AppSpacing.md),
              // Expanded(
              //   child: Row(
              //     children: [
              //       Expanded(flex: 4, child: Text('Movilidad', style: AppStyles.inputLabel, textAlign: TextAlign.right,)),
              //       Expanded(
              //         flex: 1,
              //         child: Checkbox(
              //           value: _movilidad,
              //           onChanged: (bool? value) {
              //             setState(() {
              //               _movilidad = value ?? false;
              //             });
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Text('Precio', style: AppStyles.inputLabel),
          AppTextField(controller: _priceCtrl),

          // Row(
          //   children: [
          //     Text('Otras Operaciones con Artículos', style: AppStyles.inputLabel),
          //     Checkbox(
          //       value: _otros,
          //       onChanged: (bool? value) {
          //         setState(() {
          //           _otros = value ?? false;
          //         });
          //       },
          //     ),
          //   ],
          // ),
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
          _summaryItem('Remitente', _senderNameCtrl.text),
          _summaryItem('Contacto', _senderPhoneCtrl.text),
          const Divider(),
          _summaryItem('Destinatario', _receiverNameCtrl.text),
          _summaryItem('Contacto', _receiverPhoneCtrl.text),
          const Divider(),
          _summaryItem('Cantidad', _cantidadCtrl.text),
          _summaryItem('Peso', _packageWeightCtrl.text),
          _summaryItem('Precio', _priceCtrl.text),
        ],
      ),
    );
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
              onPressed: _currentStep == 4 ? _submit : _nextStep,
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

  void _submit() {
    // Aquí luego conectas API
    debugPrint('Encomienda enviada');
  }

  // =======================
  // WIDGETS AUX
  // =======================

  Widget _summaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text('$label: ${value.isEmpty ? '-' : value}'),
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
