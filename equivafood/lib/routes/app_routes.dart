import 'package:flutter/material.dart';
import '../views/auth/login_view.dart';
import '../views/auth/registro_view.dart';
import '../views/auth/recuperar_contrasena_view.dart';
import '../views/auth/codigo_verificacion_view.dart';
import '../views/auth/cambio_contrasena_view.dart';
import '../views/home/pantalla_principal_view.dart';
import '../views/profile/perfil_view.dart';
import '../views/plan/plan_alimenticio_view.dart';
import '../views/help/ayuda_view.dart';

class AppRoutes {
  static const String login = '/login';
  static const String registro = '/registro';
  static const String recuperarContrasena = '/recuperar_contrasena';
  static const String codigoVerificacion = '/codigo_verificacion';
  static const String cambioContrasena = '/cambio_contrasena';
  static const String home = '/home';
  static const String perfil = '/perfil';
  static const String planAlimenticio = '/plan_alimenticio';
  static const String ayuda = '/ayuda';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      registro: (context) => const RegistroScreen(),
      recuperarContrasena: (context) => const RecuperarContrasenaScreen(),
      codigoVerificacion: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return CodigoVerificacionScreen(correo: args?['correo'] ?? '');
      },
      cambioContrasena: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return CambioContrasenaScreen(
          correo: args?['correo'] ?? '',
          codigo: args?['codigo'] ?? '',
        );
      },
      home: (context) => const PantallaPrincipal(),
      perfil: (context) => const PerfilScreen(),
      planAlimenticio: (context) => const PlanAlimenticioScreen(),
      ayuda: (context) => const AyudaScreen(),
    };
  }
}
