import 'package:courier/app.dart';
import 'package:courier/providers/configuraciones_provider.dart';
import 'package:courier/providers/customer_provider.dart';
import 'package:courier/providers/encomiendas_provider.dart';
import 'package:courier/providers/sucursales_provider.dart';
import 'package:courier/providers/user_provider.dart';
import 'package:courier/services/configuraciones_service.dart';
import 'package:courier/services/customer_service.dart';
import 'package:courier/services/encomienda_service.dart';
import 'package:courier/services/sucursal_service.dart';
import 'package:courier/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/api/api_client.dart';
import 'services/auth_service.dart';
import 'providers/auth_provider.dart';

void main() {
  final apiClient = ApiClient();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => CustomersProvider(CustomerService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => EncomiendasProvider(EncomiendaService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => SucursalesProvider(SucursalService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => ConfiguracionesProvider(ConfiguracionesService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => UsersProvider(UserService(apiClient)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
