import 'package:collection/collection.dart';
import 'package:courier/core/constants/buttons.dart';
import 'package:courier/core/constants/colors.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:courier/core/utils/exit_confirmation.dart';
import 'package:courier/core/widgets/customer_form.dart';
import 'package:courier/models/customer.dart';
import 'package:courier/models/direccion.dart';
import 'package:courier/models/infoByDocument.dart';
import 'package:courier/providers/configuraciones_provider.dart';
import 'package:courier/providers/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewCustomerScreen extends StatefulWidget {
  final bool esAtajo;
  const NewCustomerScreen({
    super.key, 
    this.esAtajo = false,
  });

  @override
  State<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nroDocumentoCtrl = TextEditingController();
  late final TextEditingController _razonSocialCtrl = TextEditingController();
  late final TextEditingController _departamentoCtrl = TextEditingController();
  late final TextEditingController _provinciaCtrl = TextEditingController();
  late final TextEditingController _distritoCtrl = TextEditingController();
  late final TextEditingController _direccionCtrl = TextEditingController();
  late final TextEditingController _referenciaCtrl = TextEditingController();
  late final TextEditingController _tipoClienteCtrl = TextEditingController();
  late final TextEditingController _tipoPagoCtrl = TextEditingController();
  late final TextEditingController _diasCtrl = TextEditingController();
  late final TextEditingController _igvCtrl = TextEditingController();
  late final TextEditingController _tipoDetraccionCtrl = TextEditingController();
  late final TextEditingController _planCtrl = TextEditingController();
  late final TextEditingController _extraDomDomCtrl = TextEditingController();
  late final TextEditingController _extraDomAgeCtrl = TextEditingController();
  late final TextEditingController _extraAgeDomCtrl = TextEditingController();
  late final TextEditingController _celularCtrl = TextEditingController();

  String? _departamentoValue;
  String? _provinciaValue;
  String? _distritoValue;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final config = Provider.of<ConfiguracionesProvider>(context, listen: false);
      final customers = Provider.of<CustomersProvider>(context, listen: false);
      config.getDepartamentos();
      config.getDetracciones();
      config.getPlanes();
      config.getTiposPago();
      customers.getCustomersType();
    });
  }

  void _submitNewCustomer() {
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

    String tipoPagoFinal;
    if(_diasCtrl.text != ''){
      tipoPagoFinal = '${_tipoPagoCtrl.text}_${_diasCtrl.text}';
    } else{
      tipoPagoFinal = _tipoPagoCtrl.text;
    };

    final customer = Customer(
      nroDocumento: _nroDocumentoCtrl.text.trim(),
      nombres: _razonSocialCtrl.text.trim(),
      celular: _celularCtrl.text.trim(),
      idDepartamento: departamento.idDepartamento,
      idProvincia: provincia.idProvincia,
      idDistrito: distrito.idDistrito,
      idTipoDetraccion: detraccion.idTipoDetraccion,
      idPlan: plan.idPlan,
      tipoCliente: _tipoClienteCtrl.text,
      tipoPago: tipoPagoFinal,
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

    customers.createCustomer(customer).then((_) {
      if (widget.esAtajo) {
        Navigator.pop(context, _nroDocumentoCtrl.text.trim());
      } else {
        Navigator.pop(context);
      }
    });
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

    final dep = config.departamentos.firstWhereOrNull(
      (d) => d.departamento == user.departamento,
    );

    if (dep != null) {
      await config.getProvincias(dep.idDepartamento);
      final prov = config.provincias.firstWhereOrNull(
        (p) => p.provincia == user.provincia,
      );
      if (prov != null) {
        await config.getDistritos(prov.idProvincia);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfiguracionesProvider>();
    final customer = context.watch<CustomersProvider>();

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;

          final salir = await ExitConfirmation.show(
            context,
            message: 'Se perderá toda la información llenada en el formulario para nuevo cliente',
          );

          if (salir) {
            Navigator.of(context).pop();
          }
        },
      child: Scaffold(
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
                onPressed: () async {
                  final salir = await ExitConfirmation.show(
                    context,
                    message: 'Se perderá toda la información llenada en el formulario para nuevo cliente',
                  );

                  if (salir) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              const SizedBox(width: 1),
              Text('Nuevo Cliente', style: AppStyles.titleWhite),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomerForm(
                  isEdit: false,
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
                  dias: _diasCtrl,
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
                    onPressed: _submitNewCustomer,
                    child: Text('Crear Cliente'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
