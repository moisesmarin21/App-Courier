import 'package:courier/core/constants/app_dropdownButtonFormField.dart';
import 'package:courier/core/constants/buttons.dart';
import 'package:courier/core/constants/spacing.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:courier/core/widgets/app_bar.dart';
import 'package:courier/models/motorizado.dart';
import 'package:courier/providers/sucursales_provider.dart';
import 'package:courier/providers/user_provider.dart';
import 'package:courier/screens/Modulos/modules_customer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MotorizadosScreen extends StatefulWidget {
  const MotorizadosScreen({super.key});

  @override
  State<MotorizadosScreen> createState() => _MotorizadosScreenState();
}

class _MotorizadosScreenState extends State<MotorizadosScreen> {
  final TextEditingController _sucursalCtrl = TextEditingController();
  int? _idSucursal;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<SucursalesProvider>(context, listen: false).fetchSucursales();
    });
  }

  @override
  void dispose() {
    _sucursalCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sucursalesProvider = Provider.of<SucursalesProvider>(context, listen: true);
    final usersProvider = Provider.of<UsersProvider>(context, listen: true);

    final sucursales = sucursalesProvider.sucursales;
    final motorizados = usersProvider.motorizados;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Motorizados',
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

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtrar por:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: AppSpacing.xs),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: AppDropdownbuttonformfield(
                    controller: _sucursalCtrl,
                    options: sucursales.map((e) => e.nombre).toList(),
                    hintText: 'Selecciona sucursal',
                    onChanged: (value) {
                      final sucursal = sucursales.firstWhere(
                        (s) => s.nombre == value,
                      );
                      _idSucursal = sucursal.id;
                    },
                  ),
                ),

                const SizedBox(width: AppSpacing.lg),

                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    style: AppButtonStyles.filtroBlue,
                    onPressed: () async {
                      if (_idSucursal == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Selecciona una sucursal'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      await usersProvider.getMotorizados(_idSucursal!);
                    },
                    child: Text(
                      'Aplicar',
                      style: AppStyles.buttonWhiteText,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            Expanded(
              child: motorizados.isEmpty
                  ? Center(
                      child: Text(
                        'No hay motorizados',
                        style: AppStyles.label,
                      ),
                    )
                  : ListView.separated(
                      itemCount: motorizados.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _MotorizadoCard(
                          motorizado: motorizados[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


class _MotorizadoCard extends StatelessWidget {
  final Motorizado motorizado;

  const _MotorizadoCard({required this.motorizado});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              motorizado.nombres,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.email_outlined, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    motorizado.email,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Ubicación ID: ${motorizado.idUbicacion}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
