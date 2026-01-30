import 'package:courier/core/constants/app_images.dart';
import 'package:courier/core/constants/colors.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:courier/core/widgets/app_bar.dart';
import 'package:courier/models/customer.dart';
import 'package:courier/providers/auth_provider.dart';
import 'package:courier/providers/customer_provider.dart';
import 'package:courier/routes/app_routes.dart';
import 'package:courier/screens/Modulos/modules_customer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerScreen extends StatefulWidget {
  final bool showSuccess;

  const CustomerScreen({super.key, this.showSuccess = false});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String query = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authProvider = Provider.of<AuthProvider>(context, listen: false).session;
      final idSucursal = authProvider!.idSucursal;
      Provider.of<CustomersProvider>(context, listen: false).getClientes(idSucursal);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final customersProvider = Provider.of<CustomersProvider>(context, listen: true);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Gestión de Clientes',
        onBack: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ModulesCustomer(),
            ),
          );
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      height: 30,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            query = val;
                          });
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                          hintText: 'Buscar por Nombre, Documento o Tipo de Cliente',
                          hintStyle: AppStyles.labelSmall,
                          filled: true,
                          fillColor: const Color(0xFFECEFF1),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 15,
                          ),
                          suffixIcon: query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 15, color: Colors.black),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    query = '';
                                  });
                                  FocusScope.of(context).unfocus();
                                },
                              )
                            : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: AppStyles.labelSmall,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Expanded(
                child: Stack(
                  children: [
                    customersProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : () {
                            final listaFiltrada = customersProvider.customers.where((c) {
                            final nombreCliente = c.nombres!.toLowerCase();
                            final documento = c.nroDocumento.toLowerCase();
                            final tipoCliente = c.tipoCliente!.toLowerCase();

                            return nombreCliente.contains(query.toLowerCase()) ||
                                  documento.contains(query.toLowerCase()) ||
                                  tipoCliente.contains(query.toLowerCase());
                          }).toList();

                          final agrupado = agruparPorInicial(listaFiltrada);

                          if (agrupado.isEmpty) {
                            return Center(
                              child: Text('No se encontraron clientes', style: AppStyles.label),
                            );
                          }

                          return _CustomersList(context, agrupado);
                        }(),

                    Positioned(
                      bottom: 20,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: AppColors.primary,
                          size: 45,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/newCustomer');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _CustomersList(BuildContext context, Map<String, List<Customer>> agrupado) {
    return ListView.builder(
      itemCount: agrupado.length,
      itemBuilder: (context, index) {
        String letra = agrupado.keys.elementAt(index);
        List<Customer> grupo = agrupado[letra]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(letra, style: AppStyles.labelBlue),
            ),
            ...grupo.map((c) {
              String nombreCompleto = (c.nombres!).toUpperCase();
              return Padding(
                padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editCustomer,
                      arguments: c,
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // CircleAvatar(
                      //   radius: 18,
                      //   backgroundColor: Colors.grey[300],
                      //   backgroundImage: c.fotoPerfil!.isNotEmpty
                      //     ? NetworkImage('https://adysabackend.facturador.es/archivos/clientes/${Uri.encodeComponent(c.fotoPerfil!)}')
                      //     : null,
                      //   child: c.fotoPerfil!.isEmpty
                      //     ? Icon(Icons.person, size: 30, color: AppColors.gris)
                      //     : null,
                      // ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(nombreCompleto, style: AppStyles.labelBlue),
                            const SizedBox(height: 2),
                            Text(
                              (c.distritoNombre?.isNotEmpty ?? false)
                                  ? c.distritoNombre!
                                  : 'Sin ubicación',
                              style: AppStyles.label
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: SizedBox(
                          width: 18,
                          height: 18,
                          child: Image.asset(AppImages.phone, color: Colors.black),
                        ),
                        onPressed: () async {
                          if (c.celular!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No hay número registrado')),
                            );
                            return;
                          }
                          final Uri callUri = Uri(scheme: 'tel', path: '+51${c.celular}');
                          if (await canLaunchUrl(callUri)) {
                            await launchUrl(callUri);
                          } else {
                            debugPrint('No se pudo lanzar $callUri');
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: SizedBox(
                          width: 18,
                          height: 18,
                          child: Image.asset('assets/images/whatsapp.png', color: Colors.black),
                        ),
                        onPressed: () async {
                          if (c.celular!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No hay número registrado')),
                            );
                            return;
                          }
                          final Uri whatsappUri = Uri.parse("https://wa.me/+51${c.celular}");
                          if (await canLaunchUrl(whatsappUri)) {
                            await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                          } else {
                            debugPrint('No se pudo abrir WhatsApp para +51${c.celular}');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

Map<String, List<Customer>> agruparPorInicial(List<Customer> customers) {
  Map<String, List<Customer>> agrupado = {};

  for (var customer in customers) {
    if (customer.nombres!.trim().isEmpty) continue;
    String inicial = customer.nombres![0].toUpperCase();
    if (!agrupado.containsKey(inicial)) {
      agrupado[inicial] = [];
    }
    agrupado[inicial]!.add(customer);
  }
  var keysOrdenadas = agrupado.keys.toList()..sort();
  return {
    for (var key in keysOrdenadas)
      key: (agrupado[key]!..sort((a, b) => a.nombres!.compareTo(b.nombres!)))
  };
}