import 'package:courier/models/customer.dart';
import 'package:courier/models/encomienda.dart';
import 'package:courier/screens/Modulos/encomienda/asignar_motorizado_screen.dart';
import 'package:courier/screens/Modulos/encomienda/imagen_encomienda_screen.dart';
import 'package:courier/screens/Modulos/encomienda/new_encomienda_screen.dart';
import 'package:courier/screens/Modulos/customer/edit_customer_screen.dart';
import 'package:courier/screens/Modulos/customer/new_customer_screen.dart';
import 'package:courier/screens/Modulos/encomienda/historial_estados_screen.dart';
import 'package:courier/screens/auth/font_page.dart';
import 'package:courier/screens/auth/forgot_password_screen.dart';
import 'package:courier/screens/auth/login_screen.dart';
import 'package:courier/screens/auth/reset_password_screen.dart';
import 'package:courier/screens/Modulos/modules_customer.dart';
import 'package:flutter/material.dart';


class AppRoutes {
  // Nombres de rutas
  static const String fontPage = '/';
  static const String login = '/login';
  static const String forgotPassword = '/forgot';
  static const String resetPassword = '/reset';
  
  static const String customerModule = '/customerModule';
  static const String newCustomer = '/newCustomer';
  static const String editCustomer = '/editCustomer';

  static const String newEncomienda = '/newEncomienda';
  static const String historialEstados = '/historialEstados';
  static const String imagenesEncomienda = '/imagenesEncomienda';
  static const String asignarMotorizado = '/asignarMotorizado';

  // Mapa de rutas
  static Map<String, WidgetBuilder> routes = {
    fontPage: (context) => FontPage(),
    login: (context) => LoginScreen(),
    forgotPassword: (context) => ForgotPasswordScreen(),
    resetPassword: (context) => ResetPasswordScreen(),
    
    customerModule: (context) => ModulesCustomer(),
    newCustomer: (context) => NewCustomerScreen(),
    editCustomer: (context) {
      final customer = ModalRoute.of(context)!.settings.arguments as Customer;
      return EditCustomerScreen(customer: customer);
    },

    newEncomienda: (context) => NewEncomiendaScreen(),
    historialEstados: (context) {
      final encomienda = ModalRoute.of(context)!.settings.arguments as Encomienda;
      return HistorialEstadosScreen(encomienda: encomienda);
    },

    imagenesEncomienda: (context) {
      final encomienda = ModalRoute.of(context)!.settings.arguments as Encomienda;
      return ImagenEncomiendaScreen(encomienda: encomienda);
    },

    asignarMotorizado: (context) {
      final encomienda = ModalRoute.of(context)!.settings.arguments as Encomienda;
      return AsignarMotorizadosScreen(encomienda: encomienda);
    },
  };
}
