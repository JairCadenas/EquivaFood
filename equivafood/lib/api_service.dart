import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ Cambia esta IP por la IP local de tu PC donde corre XAMPP.
  // En emulador Android usa: 10.0.2.2
  // En dispositivo físico o iOS usa tu IP local, ej: 192.168.1.100
  static const String _baseUrl = 'http://148.220.208.150/equivafood_api';

  /// Inicia sesión. Devuelve los datos del usuario o lanza una excepción con el mensaje de error.
  static Future<Map<String, dynamic>> login({
    required String correo,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/login.php');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'correo': correo, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['success'] == true) {
        return data;
      } else {
        throw Exception(
          data['message'] ?? 'Error desconocido al iniciar sesión',
        );
      }
    } on Exception {
      rethrow;
    }
  }

  /// Registra un nuevo usuario. Devuelve los datos del usuario o lanza una excepción.
  static Future<Map<String, dynamic>> registro({
    required String nombre,
    required int edad,
    required double peso,
    required double estatura,
    required String correo,
    required String password,
    String planAlimentario = 'Sin plan',
  }) async {
    final url = Uri.parse('$_baseUrl/registro.php');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'nombre': nombre,
              'edad': edad,
              'peso': peso,
              'estatura': estatura,
              'correo': correo,
              'password': password,
              'planAlimentario': planAlimentario,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['success'] == true) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Error desconocido al registrarse');
      }
    } on Exception {
      rethrow;
    }
  }
}
