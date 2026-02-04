import 'package:courier/core/constants/app_dropdownButtonFormField2.dart';
import 'package:courier/core/constants/buttons.dart';
import 'package:courier/core/constants/colors.dart';
import 'package:courier/core/constants/spacing.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:courier/core/widgets/app_bar.dart';
import 'package:courier/core/widgets/encomienda_header.dart';
import 'package:courier/models/encomienda.dart';
import 'package:courier/models/motorizado.dart';
import 'package:courier/providers/auth_provider.dart';
import 'package:courier/providers/encomiendas_provider.dart';
import 'package:courier/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AsignarMotorizadosScreen extends StatefulWidget {
  final Encomienda encomienda;

  const AsignarMotorizadosScreen({
    super.key,
    required this.encomienda
  });

  @override
  State<AsignarMotorizadosScreen> createState() => _AsignarMotorizadosScreenState();
}

class _AsignarMotorizadosScreenState extends State<AsignarMotorizadosScreen> {
  final List<String> _motorizadosAsignados = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final idEncomienda = int.parse(widget.encomienda.id!);
      Provider.of<EncomiendasProvider>(context, listen: false).getHistorialEstados(idEncomienda);
      Provider.of<EncomiendasProvider>(context, listen: false).getEstadosDisponibles(idEncomienda);
      final idSucursal  = Provider.of<AuthProvider>(context, listen: false).session!.idSucursal;
      Provider.of<UsersProvider>(context, listen: false).getMotorizados(idSucursal);
    });
  }

  void _openAsignarMotorizados(List<Motorizado> motorizados) {
    showDialog(
      context: context,
      builder: (_) => _AsignarMotorizadosDialog(
        encomienda: widget.encomienda,
        motorizados: motorizados,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final encomiendasProvider = Provider.of<EncomiendasProvider>(context, listen: true);
    final usersProvider = Provider.of<UsersProvider>(context, listen: true);
    final estadosDisponibles = encomiendasProvider.estadoDisponibles;
    final motorizados = usersProvider.motorizados;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Motorizados asignados',
        onBack: () => Navigator.pop(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EncomiendaHeader(encomienda: widget.encomienda),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),

          if (estadosDisponibles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: AppButtonStyles.primary,
                onPressed: usersProvider.isLoading
                  ? null
                  : () => _openAsignarMotorizados(motorizados),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add,
                        color: AppColors.background, size: 20),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Asignar motorizados',
                      style: AppStyles.buttonWhiteText,
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: AppSpacing.md),

          Expanded(
            child: _motorizadosAsignados.isEmpty
                ? const Center(
                    child: Text(
                      'No hay motorizados asignados',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _motorizadosAsignados.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.motorcycle),
                          title: Text(_motorizadosAsignados[i]),
                          subtitle: Text(
                            'Encomienda: ${widget.encomienda.serieRemito}',
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _AsignarMotorizadosDialog extends StatefulWidget {
  final Encomienda encomienda;
  final List<Motorizado> motorizados;

  const _AsignarMotorizadosDialog({
    required this.encomienda,
    required this.motorizados,
  });

  @override
  State<_AsignarMotorizadosDialog> createState() => _AsignarMotorizadosDialogState();
}

class _AsignarMotorizadosDialogState extends State<_AsignarMotorizadosDialog> {
  String? _motorizado1Label;
  String? _motorizado2Label;
  Motorizado? _motorizado1;
  Motorizado? _motorizado2;
  int? idEncomienda;
  int? idMotorizado1;
  int? idMotorizado2;

  @override
  Widget build(BuildContext context) {
    final encomiendasProvider = Provider.of<EncomiendasProvider>(context, listen: false);
    idEncomienda = int.parse(widget.encomienda.id!);
    idMotorizado1 = _motorizado1?.id;
    idMotorizado2 = _motorizado2?.id;
    print('Datos de envio: $idEncomienda, $idMotorizado1, $idMotorizado2');
    final motorizadosOptions = widget.motorizados
      .map((m) => m.nombres)
      .toList();

    final motorizados2Options = widget.motorizados
      .where((m) => m.id != _motorizado1?.id)
      .map((m) => m.nombres)
      .toList();

    return AlertDialog(
      title: const Text('Asignar motorizados', style: AppStyles.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: widget.encomienda.serieRemito,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Serie de encomienda',
              ),
            ),
            const SizedBox(height: 16),

            AppDropdownbuttonformfield2(
              label: 'Motorizado 1',
              hintText: 'Seleccione motorizado',
              value: _motorizado1Label,
              options: motorizadosOptions,
              onChanged: (value) {
                setState(() {
                  _motorizado1Label = value;

                  _motorizado1 = widget.motorizados.firstWhere(
                    (m) => m.nombres == value,
                  );

                  if (_motorizado2?.id == _motorizado1?.id) {
                    _motorizado2 = null;
                    _motorizado2Label = null;
                  }
                });
              },
            ),
            const SizedBox(height: 16),

            AppDropdownbuttonformfield2(
              label: 'Motorizado 2 (opcional)',
              hintText: 'Seleccione motorizado',
              value: _motorizado2Label,
              options: motorizados2Options,
              onChanged: (value) {
                setState(() {
                  _motorizado2Label = value;

                  if (value == null) {
                    _motorizado2 = null;
                    return;
                  }

                  _motorizado2 = widget.motorizados.firstWhere(
                    (m) => m.nombres == value,
                  );
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: AppButtonStyles.secondary,
          child: const Text('Cancelar', style: AppStyles.buttonText),
        ),
        ElevatedButton(
          style: AppButtonStyles.primary,
          onPressed: _motorizado1 == null
              ? null
              : () async {
                  try {
                    await encomiendasProvider.asignarMotorizadosAEncomienda(
                      idEncomienda!,
                      idMotorizado1!,
                      idMotorizado2!,
                    );

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Motorizados asignados correctamente'),
                      ),
                    );

                    Navigator.pop(context);
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error al asignar motorizados',
                        ),
                      ),
                    );
                  }
                },
          child: const Text(
            'Guardar',
            style: AppStyles.buttonWhiteText,
          ),
        ),
      ],
    );
  }
}
