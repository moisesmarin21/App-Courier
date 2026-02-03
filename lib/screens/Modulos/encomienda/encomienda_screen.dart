// EncomiendasScreen.dart
import 'package:courier/core/constants/app_dropdownButtonFormField.dart';
import 'package:courier/core/constants/buttons.dart';
import 'package:courier/core/constants/colors.dart';
import 'package:courier/core/constants/spacing.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:courier/core/widgets/app_bar.dart';
import 'package:courier/models/encomienda.dart';
import 'package:courier/providers/encomiendas_provider.dart';
import 'package:courier/providers/sucursales_provider.dart';
import 'package:courier/screens/Modulos/modules_customer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EncomiendaScreen extends StatefulWidget {
  const EncomiendaScreen({super.key});

  @override
  State<EncomiendaScreen> createState() => _EncomiendaScreenState();
}

class _EncomiendaScreenState extends State<EncomiendaScreen> {
  final TextEditingController _sucursalCtrl = TextEditingController(text: '');
  late final DateTime _fechaActual;
  late final TextEditingController _fechaInicioCtrl;
  late final TextEditingController _fechaFinCtrl;
  int? _idSucursal;

  @override
  void initState() {
    super.initState();

    _fechaActual = DateTime.now();
    final hoyApi = DateFormat('yyyy-MM-dd').format(_fechaActual);

    _fechaInicioCtrl = TextEditingController(text: hoyApi);
    _fechaFinCtrl = TextEditingController(text: hoyApi);

    Future.microtask(() {
      Provider.of<SucursalesProvider>(context, listen: false).fetchSucursales();
    });
  }

  @override
  void dispose() {
    _fechaInicioCtrl.dispose();
    _fechaFinCtrl.dispose();
    _sucursalCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate({required bool isInicio}) async {
    DateTime initialDate;
    if (isInicio && _fechaInicioCtrl.text.isNotEmpty) {
      initialDate = DateTime.tryParse(_fechaInicioCtrl.text) ?? DateTime.now();
    } else if (!isInicio && _fechaFinCtrl.text.isNotEmpty) {
      initialDate = DateTime.tryParse(_fechaFinCtrl.text) ?? DateTime.now();
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
      final formatted = DateFormat('yyyy-MM-dd').format(picked);

      setState(() {
        if (isInicio) {
          _fechaInicioCtrl.text = formatted;
        } else {
          _fechaFinCtrl.text = formatted;
        }
      });
    }
  }

  String _formatForDisplay(String value) {
    if (value.isEmpty) {
      return DateFormat('dd/MM/yyyy').format(_fechaActual);
    }
    try {
      final parsed = DateTime.parse(value);
      return DateFormat('dd/MM/yyyy').format(parsed);
    } catch (_) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sucursalesProvider = Provider.of<SucursalesProvider>(context, listen: true);
    final encomiendasProvider = Provider.of<EncomiendasProvider>(context, listen: true);
    final sucursales = sucursalesProvider.sucursales;
    final encomiendasData = encomiendasProvider.encomiendas;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Listado de Encomiendas',
        onBack: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ModulesCustomer(),
            ),
          );
        },
      ),
      backgroundColor: const Color(0xffF3F4F6),

      floatingActionButton: IconButton(
        icon: const Icon(
          Icons.add_circle,
          color: AppColors.primary,
          size: 55,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/newEncomienda');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtrar por:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: AppSpacing.lg),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha inicio', style: AppStyles.labelBlue),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                _formatForDisplay(_fechaInicioCtrl.text),
                                style: AppStyles.labelSmall,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: () => _selectDate(isInicio: true),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: AppSpacing.lg),

                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha Fin', style: AppStyles.labelBlue),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                _formatForDisplay(_fechaFinCtrl.text),
                                style: AppStyles.labelSmall,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: () => _selectDate(isInicio: false),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppDropdownbuttonformfield(
                        controller: _sucursalCtrl,
                        options: sucursales.map((e) => e.nombre).toList(),
                        onChanged: (value) {
                          final sucursalSeleccionada = sucursales.firstWhere(
                            (p) => p.nombre == value,
                          );
                          
                          _idSucursal = sucursalSeleccionada.id;
                        },
                        hintText: 'Selecciona sucursal',
                        padding: const EdgeInsets.only(bottom: 10),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: AppSpacing.lg),

                Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: AppButtonStyles.filtroBlue,
                      onPressed: () async {
                        if (_idSucursal == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor selecciona una sucursal antes de aplicar el filtro.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        if (_fechaInicioCtrl.text.isEmpty) {
                          _fechaInicioCtrl.text = DateFormat('yyyy-MM-dd').format(_fechaActual);
                        }
                        if (_fechaFinCtrl.text.isEmpty) {
                          _fechaFinCtrl.text = DateFormat('yyyy-MM-dd').format(_fechaActual);
                        }

                        final inicio = DateTime.parse(_fechaInicioCtrl.text);
                        final fin = DateTime.parse(_fechaFinCtrl.text);

                        final diferenciaDias = fin.difference(inicio).inDays;

                        if (diferenciaDias > 15) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('El rango máximo permitido para el filtro es de 15 días.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                        
                        await encomiendasProvider.getEncomiendas(
                          _idSucursal!,
                          _fechaInicioCtrl.text,
                          _fechaFinCtrl.text,
                        );
                      },
                      child: Text('Aplicar', style: AppStyles.buttonWhiteText),
                    ),
                  ),
                ),
              ],
            ),
            
            const Divider(height: 24, thickness: 1, color: Colors.grey),

            Expanded(
              child: encomiendasData.isEmpty
                  ? Center(
                      child: Text(
                        'No hay datos', style: AppStyles.label,
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: encomiendasData.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final encomienda = encomiendasData[index];
                        return _EncomiendaCard(encomienda: encomienda);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EncomiendaCard extends StatelessWidget {
  final Encomienda encomienda;

  const _EncomiendaCard({required this.encomienda});
  
  @override
  Widget build(BuildContext context) {
    String estadoCompleto = encomienda.ultimoEstado!;
    String estadoSolo = estadoCompleto.split(' ')[0].trim();
    bool esAgencia = estadoSolo == 'AGENCIA';
    String resto = estadoCompleto.split('<br>')[0].trim();

    Widget estadoChip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.estadoColor(estadoSolo).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: esAgencia
            ? Border.all(color: AppColors.estadoColor(estadoSolo))
            : null,
      ),
      child: Text(
        estadoSolo,
        style: TextStyle(
          color: AppColors.estadoColor(estadoSolo),
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    Widget estadoWidget = esAgencia
        ? Tooltip(
            message: resto,
            preferBelow: false,
            waitDuration: const Duration(milliseconds: 300),
            showDuration: const Duration(seconds: 3),
            child: estadoChip,
          )
        : estadoChip;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  encomienda.serieRemito!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    estadoWidget,
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/historialEstados',
                          arguments: encomienda,
                        );
                      },
                      icon: const Icon(Icons.change_circle),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            _InfoRow(
              label: 'Remitente',
              value: encomienda.remitente!,
              direccion: encomienda.remitenteDireccion,
            ),
            _InfoRow(
              label: 'Destinatario',
              value: encomienda.destinatario!,
              direccion: encomienda.destinatarioDireccion,
            ),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: _InfoRow(
                    label: 'Origen',
                    value: encomienda.agenciaOrigen!,
                  ),
                ),
                Expanded(
                  child: _InfoRow(
                    label: 'Destino',
                    value: encomienda.agenciaDestino!,
                  ),
                ),
              ],
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: (){}, 
                  icon: Icon(Icons.photo_library, color: AppColors.primary)
                ),
                Text(
                  'Fecha: ${encomienda.fechaEntrega}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final String? direccion;

  const _InfoRow({required this.label, required this.value, this.direccion});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          if (direccion != null && direccion!.isNotEmpty)
            Text(
              direccion!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }
}
