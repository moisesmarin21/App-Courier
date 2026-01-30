import 'package:courier/core/constants/app_dropdownButtonFormField2.dart';
import 'package:courier/core/constants/app_textFormField.dart';
import 'package:courier/core/constants/spacing.dart';
import 'package:courier/models/infoByDocument.dart';
import 'package:courier/providers/configuraciones_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CustomerForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController nroDocumento;
  final TextEditingController razonSocial;
  final TextEditingController departamento;
  final TextEditingController provincia;
  final TextEditingController distrito;
  final TextEditingController direccion;
  final TextEditingController referencia;
  final TextEditingController tipoCliente;
  final TextEditingController tipoPago;
  final TextEditingController? dias;
  final TextEditingController igv;
  final TextEditingController tipoDetraccion;
  final TextEditingController plan;
  final TextEditingController extraDomDom;
  final TextEditingController extraDomAge;
  final TextEditingController extraAgeDom;
  final TextEditingController celular;

  final List<String> departamentos;
  final List<String> provincias;
  final List<String> distritos;
  final List<String> tiposCliente;
  final List<String> detracciones;
  final List<String> planes;
  final List<String> tiposPago;

  final ValueChanged<String?> onDepartamentoChanged;
  final ValueChanged<String?> onProvinciaChanged;
  final ValueChanged<String?> onDistritoChanged;

  final void Function(InfoByDocument user) onClienteEncontrado;

  const CustomerForm({
    super.key,
    required this.formKey,
    required this.nroDocumento,
    required this.razonSocial,
    required this.departamento,
    required this.provincia,
    required this.distrito,
    required this.direccion,
    required this.referencia,
    required this.tipoCliente,
    required this.tipoPago,
    this.dias,
    required this.igv,
    required this.tipoDetraccion,
    required this.plan,
    required this.extraDomDom,
    required this.extraDomAge,
    required this.extraAgeDom,
    required this.celular,
    required this.departamentos,
    required this.provincias,
    required this.distritos,
    required this.tiposCliente,
    required this.detracciones,
    required this.planes,
    required this.tiposPago,
    required this.onDepartamentoChanged,
    required this.onProvinciaChanged,
    required this.onDistritoChanged,
    required this.onClienteEncontrado,
  });

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  bool _esCredito = false;

  @override
  Widget build(BuildContext context) {
    final configuracionesProvider = context.watch<ConfiguracionesProvider>();
    final List<String> igvOptions = ['Si','No'];
    int _igvValue;

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextFormField(
                  controller: widget.nroDocumento,
                  label: 'RUC/DNI',
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                ),
              ),
              
              SizedBox(
                child: IconButton(
                  tooltip: 'Buscar cliente',
                  onPressed: () async {
                    final documento = widget.nroDocumento.text.trim();

                    if (documento.length != 8 && documento.length != 11) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El número de documento debe tener 8 (DNI) o 11 (RUC) dígitos.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    if (documento.length == 8) {
                      await configuracionesProvider.getInfoByDni(documento);
                    } else if (documento.length == 11) {
                      await configuracionesProvider.getInfoByRuc(documento);
                    }

                    final user = configuracionesProvider.cliente;
                    if (user == null) return;

                    widget.onClienteEncontrado(user);
                  },
                  icon: const Icon(Icons.search),
                )
              )
            ],
          ),

          AppTextFormField(controller: widget.razonSocial, label: 'Razón Social'),

          AppDropdownbuttonformfield2(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            label: 'Departamento', 
            controller: widget.departamento, 
            options: widget.departamentos, 
            onChanged: widget.onDepartamentoChanged,
            // POR VERIFICAR
            // hintText: 'Departamento',
          ),

          Row(
            children: [
              Expanded(
                child: AppDropdownbuttonformfield2(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  label: 'Provincia', 
                  controller: widget.provincia, 
                  options: widget.provincias, 
                  onChanged: widget.onProvinciaChanged,
                  // POR VERIFICAR
                  // hintText: 'Provincia',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppDropdownbuttonformfield2(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  label: 'Distrito', 
                  controller: widget.distrito, 
                  options: widget.distritos, 
                  onChanged: widget.onDistritoChanged,
                  // POR VERIFICAR
                  // hintText: 'Ditrito',
                ),
              ),
            ],
          ),

          AppTextFormField(controller: widget.direccion, label: 'Dirección'),
          AppTextFormField(
            controller: widget.referencia, 
            label: 'Referencia',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          Row(
            children: [
              Expanded(
                child: AppDropdownbuttonformfield2(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  label: 'Tipo Cliente', 
                  controller: widget.tipoCliente, 
                  options: widget.tiposCliente, 
                  onChanged: (value) {
                    widget.tipoCliente.text = value!;
                  },
                  // POR VERIFICAR
                  // hintText: 'Tipo Cliente',
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              Expanded(
                child: AppDropdownbuttonformfield2(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  label: 'Tipo Pago', 
                  controller: widget.tipoPago, 
                  options: widget.tiposPago, 
                  onChanged: (value) {
                    setState(() {
                      widget.tipoPago.text = value!;

                      _esCredito = value == 'credito';
                      if (_esCredito) {
                        widget.dias!.text = '';
                      } else {
                        widget.dias!.clear();
                      }
                    });
                  },
                ),
              ),
            ],
          ),

          if (_esCredito) ...[
            AppTextFormField(
              controller: widget.dias!, 
              label: 'Dias (Crédito)',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ],
          
          Row(
            children: [
              Expanded(
                child: AppDropdownbuttonformfield2(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  label: 'Incluye IGV',
                  controller: widget.igv, 
                  options: igvOptions, 
                  onChanged: (value) => widget.igv.text = value!,
                  // _igvValue = value == 'Si' ? 1 : 0;
                  // POR VERIFICAR
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              Expanded(
                child: AppDropdownbuttonformfield2(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  label: 'Tipo Detracción', 
                  controller: widget.tipoDetraccion, 
                  options: widget.detracciones, 
                  onChanged: (value) {
                    widget.tipoDetraccion.text = value!;
                  },
                  // ENVIAR ID
                  // hintText: 'Tipo Detracción',
                ),
              ),
            ],
          ),

          AppDropdownbuttonformfield2(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            label: 'Plan', 
            controller: widget.plan, 
            options: widget.planes, 
            onChanged: (value) {
              widget.plan.text = value!;
            },
            // ENVIAR ID
            // hintText: 'Plan',
          ),

          AppTextFormField(
            controller: widget.extraDomDom, 
            label: 'Extra Dom-Dom',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.isEmpty) return newValue;
                final intValue = int.tryParse(newValue.text);
                if (intValue != null && intValue <= 100) return newValue;
                return oldValue;
              }),
            ],
          ),
          AppTextFormField(
            controller: widget.extraDomAge, 
            label: 'Extra Dom-Age',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.isEmpty) return newValue;
                final intValue = int.tryParse(newValue.text);
                if (intValue != null && intValue <= 100) return newValue;
                return oldValue;
              }),
            ],
          ),
          AppTextFormField(
            controller: widget.extraAgeDom, 
            label: 'Extra Age-Dom',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.isEmpty) return newValue;
                final intValue = int.tryParse(newValue.text);
                if (intValue != null && intValue <= 100) return newValue;
                return oldValue;
              }),
            ],
          ),
          AppTextFormField(
            controller: widget.celular, 
            label: 'Celular',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ],
      ),
    );
  }
}
