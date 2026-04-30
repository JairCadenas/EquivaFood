import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importa tus archivos
import 'routes/app_routes.dart';
import 'services/api_service.dart';
import 'views/home/pantalla_principal_view.dart';
import 'views/auth/login_view.dart'; // Moveremos LoginScreen aquí

void main() async {
  // 1. Aseguramos que Flutter esté listo
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Cargamos variables desde assets/.env
  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    debugPrint(
      "Error crítico: No se encontró assets/.env. Revisa pubspec.yaml",
    );
  }

  // 3. Inicializamos Supabase usando las variables del archivo .env
  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
  );

  // 4. VERIFICAR SI YA HAY UNA SESIÓN INICIADA
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // 5. Arrancamos la app pasando el estado del login
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EquivaFood',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF33D1C1),
        useMaterial3: true,
      ),
      initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
      routes: AppRoutes.getRoutes(),
    );
  }
}

