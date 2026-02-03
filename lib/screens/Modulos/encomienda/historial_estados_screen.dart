import 'package:courier/core/constants/buttons.dart';
import 'package:courier/core/constants/colors.dart';
import 'package:courier/core/constants/spacing.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:courier/core/widgets/app_bar.dart';
import 'package:courier/models/encomienda.dart';
import 'package:courier/models/historialEstado.dart';
import 'package:courier/providers/encomiendas_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistorialEstadosScreen extends StatefulWidget {
  final Encomienda encomienda;

  const HistorialEstadosScreen({
    super.key,
    required this.encomienda,
  });

  @override
  State<HistorialEstadosScreen> createState() =>
      _HistorialEstadosScreenState();
}

class _HistorialEstadosScreenState extends State<HistorialEstadosScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<EncomiendasProvider>(context, listen: false).getHistorialEstados(widget.encomienda.id!);
      Provider.of<EncomiendasProvider>(context, listen: false).getEstadosDisponibles(widget.encomienda.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final encomiendasProvider = Provider.of<EncomiendasProvider>(context, listen: true);
    final estadosDisponibles = encomiendasProvider.estadoDisponibles;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Historial de estados',
        onBack: () => Navigator.pop(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EncomiendaHeader(encomienda: widget.encomienda),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),
          
          if (estadosDisponibles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: ElevatedButton(
                style: AppButtonStyles.primary,
                onPressed: () => _openNuevoEstadoForm(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppColors.background, size: 20),
                    const SizedBox(width: AppSpacing.xs),
                    Text('Cambiar Estado', style: AppStyles.buttonWhiteText),
                  ],
                ),
              ),
            ),

          Expanded(
            child: encomiendasProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : encomiendasProvider.historialEstados.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay estados registrados',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: encomiendasProvider.historialEstados.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final estado =
                              encomiendasProvider.historialEstados[index];

                          return _EstadoCard(estado: estado);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _openNuevoEstadoForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _NuevoEstadoForm(
        idEncomienda: widget.encomienda.id!,
      ),
    );
  }
}

class _NuevoEstadoForm extends StatefulWidget {
  final String idEncomienda;

  const _NuevoEstadoForm({required this.idEncomienda});

  @override
  State<_NuevoEstadoForm> createState() => _NuevoEstadoFormState();
}

class _NuevoEstadoFormState extends State<_NuevoEstadoForm> {
  final _formKey = GlobalKey<FormState>();
  int? _idEstado;
  final TextEditingController _comentarioCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final encomiendasProvider = Provider.of<EncomiendasProvider>(context, listen: true);
    final estadosDisponibles = encomiendasProvider.estadoDisponibles;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            const Text(
              'Cambiar estado',
              style: AppStyles.subtitleBlue
            ),

            const SizedBox(height: 16),

            // Select de estados
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Nuevo estado',
                labelStyle: AppStyles.labelBlue,
                border: OutlineInputBorder(),
              ),
              items: estadosDisponibles.map((estado) {
                return DropdownMenuItem<int>(
                  value: estado.id,
                  child: Text(estado.nombre),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _idEstado = value);
              },
              validator: (value) =>
                  value == null ? 'Seleccione un estado' : null,
            ),

            const SizedBox(height: 12),

            // Comentario
            TextFormField(
              controller: _comentarioCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Comentario',
                labelStyle: AppStyles.labelBlue,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Botón guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    encomiendasProvider.addEstadoEncomienda(
                      int.parse(widget.idEncomienda),
                      _idEstado!,
                      _comentarioCtrl.text,
                    );

                    Navigator.pop(context);
                  }
                },
                style: AppButtonStyles.primary,
                child: const Text('Guardar estado', style: AppStyles.buttonWhiteText),
              ),
            ),

            const SizedBox(height: AppSpacing.md)
          ],
        ),
      ),
    );
  }
}


class _EncomiendaHeader extends StatelessWidget {
  final Encomienda encomienda;

  const _EncomiendaHeader({required this.encomienda});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Remito ${encomienda.serieRemito}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Origen: ${encomienda.agenciaOrigen}  •  Destino: ${encomienda.agenciaDestino}',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _EstadoCard extends StatelessWidget {
  final HistorialEstado estado;

  const _EstadoCard({required this.estado});

  @override
  Widget build(BuildContext context) {
    final String nombreEstado = estado.nombre;
    final String fecha = estado.fecha;
    final String hora = estado.hora;
    final String comentario = estado.comentario;
    final String personal = estado.nombrePersonal;
    final String agencia = estado.nombreAgencia;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicador de estado
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: AppColors.estadoColor(nombreEstado),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Estado
                  Text(
                    nombreEstado,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Comentario
                  Text(
                    comentario,
                    style: const TextStyle(fontSize: 13),
                  ),

                  const SizedBox(height: 6),

                  // Fecha y hora
                  Text(
                    '$fecha • $hora',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Personal y agencia (si hay)
                  Text(
                    agencia.isNotEmpty
                        ? 'Por $personal — $agencia'
                        : 'Por $personal',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


