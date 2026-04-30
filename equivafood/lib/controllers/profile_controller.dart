import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/api_service.dart';

class ProfileController {
  static Future<Map<String, dynamic>> obtenerDatosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('userEmail');

    if (email == null || email.isEmpty) {
      throw Exception('No hay sesión activa');
    }

    final data = await Supabase.instance.client
        .from('usuario')
        .select()
        .eq('correo', email)
        .single();

    return {
      'correo': email,
      'datos': data,
    };
  }

  static Future<void> actualizarPerfil({
    required String correoUsuario,
    required String nombre,
    required int edad,
    required double peso,
    required double estatura,
    required String? urlActual,
    File? nuevaImagen,
  }) async {
    String? nuevaUrl = urlActual;
    
    if (nuevaImagen != null) {
      nuevaUrl = await ApiService.subirImagen(nuevaImagen, correoUsuario);
    }

    await ApiService.actualizarPerfil(
      correo: correoUsuario,
      nombre: nombre,
      edad: edad,
      peso: peso,
      estatura: estatura,
      avatarUrl: nuevaUrl,
    );
  }
}
