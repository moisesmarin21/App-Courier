import 'package:collection/collection.dart';
import 'package:courier/core/constants/buttons.dart';
import 'package:courier/core/constants/colors.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:courier/core/widgets/customer_form.dart';
import 'package:courier/models/customer.dart';
import 'package:courier/models/direccion.dart';
import 'package:courier/models/infoByDocument.dart';
import 'package:courier/providers/configuraciones_provider.dart';
import 'package:courier/providers/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCustomerScreen extends StatefulWidget {
  final Customer customer;
  const EditCustomerScreen({super.key, required this.customer});

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nroDocumentoCtrl;
  late final TextEditingController _razonSocialCtrl;
  late final TextEditingController _departamentoCtrl;
  late final TextEditingController _provinciaCtrl;
  late final TextEditingController _distritoCtrl;
  late final TextEditingController _direccionCtrl;
  late final TextEditingController _referenciaCtrl;
  late final TextEditingController _tipoClienteCtrl;
  late final TextEditingController _tipoPagoCtrl;
  late final TextEditingController _igvCtrl;
  late final TextEditingController _tipoDetraccionCtrl;
  late final TextEditingController _planCtrl;
  late final TextEditingController _extraDomDomCtrl;
  late final TextEditingController _extraDomAgeCtrl;
  late final TextEditingController _extraAgeDomCtrl;
  late final TextEditingController _celularCtrl;

  String? _departamentoValue;
  String? _provinciaValue;
  String? _distritoValue;

  void _submitEditCustomer() {
    if (!_formKey.currentState!.validate()) return;
    final config = context.read<ConfiguracionesProvider>();
    final customers = context.read<CustomersProvider>();
    final departamento = config.departamentos
        .firstWhere((d) => d.departamento == _departamentoCtrl.text);
    final provincia = config.provincias
        .firstWhere((p) => p.provincia == _provinciaCtrl.text);
    final distrito = config.distritos
        .firstWhere((d) => d.distrito == _distritoCtrl.text);
    final detraccion = config.detracciones
        .firstWhere((d) => d.tipoDetraccion == _tipoDetraccionCtrl.text);
    final plan = config.planes
        .firstWhere((p) => p.plan == _planCtrl.text);

    final updatedCustomer = Customer(
      id: widget.customer.id,
      nroDocumento: _nroDocumentoCtrl.text.trim(),
      nombres: _razonSocialCtrl.text.trim(),
      celular: _celularCtrl.text.trim(),

      idDepartamento: departamento.idDepartamento,
      idProvincia: provincia.idProvincia,
      idDistrito: distrito.idDistrito,
      idTipoDetraccion: detraccion.idTipoDetraccion,
      idPlan: plan.idPlan,

      tipoCliente: _tipoClienteCtrl.text,
      tipoPago: _tipoPagoCtrl.text,
      igv: _igvCtrl.text == 'Si' ? 1 : 0,

      extraDomDom: int.tryParse(_extraDomDomCtrl.text),
      extraDomAge: int.tryParse(_extraDomAgeCtrl.text),
      extraAgeDom: int.tryParse(_extraAgeDomCtrl.text),

      direcciones: [
        Direccion(
          direccion: _direccionCtrl.text.trim(),
          referencia: _referenciaCtrl.text.trim(),
        ),
      ],
    );

    customers.updateCustomer(updatedCustomer).then((_) {
      Navigator.pop(context);
    });
  }

  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final customers = context.read<CustomersProvider>();
      final config = context.read<ConfiguracionesProvider>();

      await Future.wait([
        customers.getClienteById(widget.customer.id!),
        config.getDepartamentos(),
        config.getDetracciones(),
        config.getTiposPago(),
        config.getPlanes(),
        customers.getCustomersType(),
      ]);

      final c = customers.customerById;
      if (c == null) return;

      // Inicializar controllers
      _initControllers(c, config);

      // Si no hay departamento, no hay jerarquía
      if (c.departamentoNombre == null || c.departamentoNombre!.isEmpty) {
        setState(() => _controllersInitialized = true);
        return;
      }

      final departamento = config.departamentos.firstWhereOrNull(
        (d) => d.departamento == c.departamentoNombre,
      );

      // Si no existe en catálogo, se limpian los selects
      if (departamento == null) {
        _provinciaValue = null;
        _distritoValue = null;
        config.clearProvincias();
        config.clearDistritos();

        setState(() => _controllersInitialized = true);
        return;
      }
      await config.getProvincias(departamento.idDepartamento);

      if (c.provinciaNombre == null || c.provinciaNombre!.isEmpty) {
        setState(() => _controllersInitialized = true);
        return;
      }
      final provincia = config.provincias.firstWhereOrNull(
        (p) => p.provincia == c.provinciaNombre,
      );

      if (provincia == null) {
        _distritoValue = null;
        config.clearDistritos();

        setState(() => _controllersInitialized = true);
        return;
      }
      await config.getDistritos(provincia.idProvincia);
      setState(() => _controllersInitialized = true);
    });
  }

  void _initControllers(Customer c, ConfiguracionesProvider config) {
    _nroDocumentoCtrl = TextEditingController(text: c.nroDocumento ?? '');
    _razonSocialCtrl = TextEditingController(text: c.nombres ?? '');

    _departamentoValue = c.departamentoNombre;
    _provinciaValue = c.provinciaNombre;
    _distritoValue = c.distritoNombre;

    _departamentoCtrl =
        TextEditingController(text: c.departamentoNombre ?? '');
    _provinciaCtrl =
        TextEditingController(text: c.provinciaNombre ?? '');
    _distritoCtrl =
        TextEditingController(text: c.distritoNombre ?? '');

    _direccionCtrl = TextEditingController(
      text: c.direcciones.isNotEmpty ? c.direcciones.last.direccion : '',
    );

    _referenciaCtrl = TextEditingController(
      text: c.direcciones.isNotEmpty ? c.direcciones.last.referencia : '',
    );

    _tipoClienteCtrl = TextEditingController(text: c.tipoCliente ?? '');
    _tipoPagoCtrl = TextEditingController(text: c.tipoPago ?? '');

    _igvCtrl = TextEditingController(
      text: c.igv == 1 ? 'Si' : 'No',
    );

    _tipoDetraccionCtrl = TextEditingController(
      text: config.detracciones
          .firstWhereOrNull(
            (d) => d.idTipoDetraccion == c.idTipoDetraccion,
          )
          ?.tipoDetraccion ??
          '',
    );

    _planCtrl = TextEditingController(text: c.planNombre ?? '');

    _extraDomDomCtrl =
        TextEditingController(text: c.extraDomDom?.toString() ?? '');
    _extraDomAgeCtrl =
        TextEditingController(text: c.extraDomAge?.toString() ?? '');
    _extraAgeDomCtrl =
        TextEditingController(text: c.extraAgeDom?.toString() ?? '');

    _celularCtrl = TextEditingController(text: c.celular ?? '');
  }

  void _onDepartamentoChanged(String? value) async {
    if (value == null || value == _departamentoValue) return;
    final config = context.read<ConfiguracionesProvider>();
    setState(() {
      _departamentoValue = value;
      _provinciaValue = null;
      _distritoValue = null;
      _departamentoCtrl.text = value;
      _provinciaCtrl.clear();
      _distritoCtrl.clear();
    });

    final dep = config.departamentos.firstWhereOrNull(
      (d) => d.departamento == value,
    );

    if (dep == null) return;
    config.clearProvincias();
    config.clearDistritos();
    await config.getProvincias(dep.idDepartamento);
  }

  void _onProvinciaChanged(String? value) async {
    if (value == null || value == _provinciaValue) return;
    final config = context.read<ConfiguracionesProvider>();
    setState(() {
      _provinciaValue = value;
      _distritoValue = null;
      _provinciaCtrl.text = value;
      _distritoCtrl.clear();
    });

    final prov = config.provincias.firstWhereOrNull(
      (p) => p.provincia == value,
    );

    if (prov == null) return;
    config.clearDistritos();
    await config.getDistritos(prov.idProvincia);
  }

  void _onDistritoChanged(String? value) {
    setState(() {
      _distritoValue = value;
      _distritoCtrl.text = value ?? '';
    });
  }

  void _onClienteEncontrado(InfoByDocument user) async {
    final config = context.read<ConfiguracionesProvider>();

    _razonSocialCtrl.text = user.razonSocial ?? '';

    _departamentoValue = user.departamento;
    _provinciaValue = user.provincia;
    _distritoValue = user.distrito;

    _departamentoCtrl.text = user.departamento ?? '';
    _provinciaCtrl.text = user.provincia ?? '';
    _distritoCtrl.text = user.distrito ?? '';

    if (user.departamento == null) {
      setState(() {});
      return;
    }

    final dep = config.departamentos.firstWhereOrNull(
      (d) => d.departamento == user.departamento,
    );

    if (dep == null) return;

    await config.getProvincias(dep.idDepartamento);

    final prov = config.provincias.firstWhereOrNull(
      (p) => p.provincia == user.provincia,
    );

    if (prov != null) {
      await config.getDistritos(prov.idProvincia);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfiguracionesProvider>();
    final customer = context.watch<CustomersProvider>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 1),
            Text('Editar Cliente', style: AppStyles.titleWhite),
          ],
        ),
      ),
      body: !_controllersInitialized
      ? const Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomerForm(
                formKey: _formKey,
                nroDocumento: _nroDocumentoCtrl,
                razonSocial: _razonSocialCtrl,
                departamento: _departamentoCtrl,
                provincia: _provinciaCtrl,
                distrito: _distritoCtrl,
                direccion: _direccionCtrl,
                referencia: _referenciaCtrl,
                tipoCliente: _tipoClienteCtrl,
                tipoPago: _tipoPagoCtrl,
                igv: _igvCtrl,
                tipoDetraccion: _tipoDetraccionCtrl,
                plan: _planCtrl,
                extraDomDom: _extraDomDomCtrl,
                extraDomAge: _extraDomAgeCtrl,
                extraAgeDom: _extraAgeDomCtrl,
                celular: _celularCtrl,
                departamentos: config.departamentos.map((e) => e.departamento).toList(),
                provincias: config.provincias.map((e) => e.provincia).toList(),
                distritos: config.distritos.map((e) => e.distrito).toList(),
                tiposCliente: customer.customersType.map((e) => e.tipoCliente).toList(),
                detracciones: config.detracciones.map((e) => e.tipoDetraccion).toList(),
                planes: config.planes.map((e) => e.plan).toList(),
                tiposPago: config.tiposPago.map((e) => e.tipoPago).toList(),
                onDepartamentoChanged: _onDepartamentoChanged,
                onProvinciaChanged: _onProvinciaChanged,
                onDistritoChanged: _onDistritoChanged,
                onClienteEncontrado: _onClienteEncontrado,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: AppButtonStyles.primary,
                  onPressed: null,
                  child: Text('Actualizar Cliente'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
