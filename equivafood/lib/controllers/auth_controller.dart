import 'dart:io';
import '../services/api_service.dart';

class AuthController {
  // Manejo de inicio de sesión
  static Future<void> login(String correo, String password) async {
    await ApiService.login(correo: correo, password: password);
  }

  // Manejo de registro
  static Future<Map<String, dynamic>> registro({
    required String nombre,
    required int edad,
    required double peso,
    required double estatura,
    required String correo,
    required String password,
    File? imageFile,
  }) async {
    String? avatarUrl;

    if (imageFile != null) {
      avatarUrl = await ApiService.subirImagen(imageFile, correo);
    }

    return await ApiService.registro(
      nombre: nombre,
      edad: edad,
      peso: peso,
      estatura: estatura,
      correo: correo,
      password: password,
      avatarUrl: avatarUrl,
    );
  }

  // Recuperación de contraseña
  static Future<void> solicitarRecuperacion(String correo) async {
    await ApiService.enviarCodigoRecuperacion(correo: correo);
  }

  // Verificar código
  static Future<void> verificarCodigo(String correo, String codigo) async {
    await ApiService.verificarCodigo(correo: correo, codigo: codigo);
  }

  // Cambiar contraseña final
  static Future<void> cambiarContrasena(
      String correo, String codigo, String nuevaPassword) async {
    await ApiService.cambiarContrasena(
      correo: correo,
      codigo: codigo,
      nuevaPassword: nuevaPassword,
    );
  }
}
