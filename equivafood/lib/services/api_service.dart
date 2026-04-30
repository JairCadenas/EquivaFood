import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Cliente de Supabase para realizar peticiones a la base de datos y al storage
  static final _supabase = Supabase.instance.client;

  // Getters para recuperar las credenciales de correo desde el archivo .env
  static String get _usuarioCorreo => dotenv.get('SMTP_EMAIL', fallback: '');
  static String get _passwordApp => dotenv.get('SMTP_PASSWORD', fallback: '');

  // ── SUBIR IMAGEN A STORAGE ────────────────────────────────────────────────
  // Sube un archivo fisico al bucket 'avatars' y retorna la URL publica
  static Future<String?> subirImagen(File imageFile, String email) async {
    try {
      // Generacion de un nombre unico para el archivo usando el correo y un timestamp
      final String fileName =
          'avatar_${email}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Peticion de subida al bucket 'avatars'
      await _supabase.storage
          .from('avatars')
          .upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Obtencion de la URL publica necesaria para mostrar la imagen en la app
      final String publicUrl = _supabase.storage
          .from('avatars')
          .getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      print('Error en ApiService.subirImagen: $e');
      return null;
    }
  }

  // ── INICIO DE SESIÓN ──────────────────────────────────────────────────────
  // Valida credenciales y guarda la sesion localmente mediante SharedPreferences
  static Future<Map<String, dynamic>> login({
    required String correo,
    required String password,
  }) async {
    try {
      // Consulta a la tabla 'usuario' buscando coincidencia de correo y password
      final data = await _supabase
          .from('usuario')
          .select()
          .eq('correo', correo)
          .eq('password', password)
          .maybeSingle();

      if (data == null) {
        throw Exception('Correo o contraseña incorrectos');
      }

      // Persistencia local de los datos del usuario para evitar re-logueos innecesarios
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userName', data['nombre'] ?? 'Usuario');
      await prefs.setString('userEmail', data['correo'] ?? '');
      await prefs.setString('userPeso', data['peso']?.toString() ?? '0');
      await prefs.setString(
        'userEstatura',
        data['estatura']?.toString() ?? '0',
      );

      // Guardado de la URL del avatar en preferencias locales si el usuario tiene una
      if (data['avatar_url'] != null) {
        await prefs.setString('userAvatar', data['avatar_url']);
      }

      return data;
    } catch (e) {
      throw Exception('Error en el login: $e');
    }
  }

  // ── REGISTRO DE USUARIO ───────────────────────────────────────────────────
  // Crea un nuevo registro en la base de datos con toda la informacion del perfil
  static Future<Map<String, dynamic>> registro({
    required String nombre,
    required int edad,
    required double peso,
    required double estatura,
    required String correo,
    required String password,
    String? planAlimentario,
    String?
    avatarUrl, // Parametro opcional que recibe la URL generada en Storage
  }) async {
    try {
      // Insercion de datos en la tabla 'usuario'. Se incluye la URL del avatar
      final response = await _supabase.from('usuario').insert({
        'nombre': nombre,
        'edad': edad,
        'peso': peso,
        'estatura': estatura,
        'correo': correo,
        'password': password,
        'planalimentario': planAlimentario,
        'avatar_url':
            avatarUrl, // Persistencia de la URL en la columna de la DB
      }).select();

      return response.first;
    } catch (e) {
      throw Exception('Error al registrar: $e');
    }
  }

  // ── RECUPERACIÓN DE CONTRASEÑA ─────────────────────────────────────────────
  // Genera un codigo aleatorio, lo guarda en la DB y lo envia por correo via SMTP
  static Future<void> enviarCodigoRecuperacion({required String correo}) async {
    try {
      // Generacion de codigo de 6 digitos
      final String codigo = (100000 + (DateTime.now().microsecond % 900000))
          .toString();

      // Registro del codigo con tiempo de expiracion de 15 minutos
      await _supabase.from('codigorecuperacion').upsert({
        'correo': correo,
        'codigo': codigo,
        'expira_en': DateTime.now()
            .add(const Duration(minutes: 15))
            .toIso8601String(),
      });

      if (_usuarioCorreo.isEmpty || _passwordApp.isEmpty) {
        throw Exception('Credenciales SMTP no configuradas en el .env');
      }

      // Configuracion del servidor de correo y envio del mensaje HTML
      final smtpServer = gmail(_usuarioCorreo, _passwordApp);
      final message = Message()
        ..from = Address(_usuarioCorreo, 'EquivaFood Soporte')
        ..recipients.add(correo)
        ..subject = 'Código de Recuperación - EquivaFood'
        ..html =
            """
          <div style="font-family: sans-serif; border: 1px solid #33D1C1; padding: 20px; border-radius: 10px;">
            <h2 style="color: #33D1C1;">Restablecer Contraseña</h2>
            <p>Has solicitado un código para cambiar tu contraseña en <b>EquivaFood</b>.</p>
            <p style="font-size: 20px;">Tu código de seguridad es: <b>$codigo</b></p>
            <p>Este código expira en 15 minutos.</p>
          </div>
        """;

      await send(message, smtpServer);
    } catch (e) {
      throw Exception('No se pudo enviar el código: $e');
    }
  }

  // ── VERIFICAR CÓDIGO ──────────────────────────────────────────────────────
  // Valida que el codigo ingresado sea correcto y que no haya expirado
  static Future<void> verificarCodigo({
    required String correo,
    required String codigo,
  }) async {
    try {
      final res = await _supabase
          .from('codigorecuperacion')
          .select()
          .eq('correo', correo)
          .eq('codigo', codigo)
          .maybeSingle();

      if (res == null) throw Exception('Código incorrecto');

      final expiraEn = DateTime.parse(res['expira_en']);
      if (DateTime.now().isAfter(expiraEn))
        throw Exception('El código ha expirado');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ── CAMBIAR CONTRASEÑA FINAL ──────────────────────────────────────────────
  // Actualiza la contraseña en la tabla de usuarios y limpia el codigo usado
  static Future<void> cambiarContrasena({
    required String correo,
    required String codigo,
    required String nuevaPassword,
  }) async {
    try {
      await verificarCodigo(correo: correo, codigo: codigo);
      await _supabase
          .from('usuario')
          .update({'password': nuevaPassword})
          .eq('correo', correo);

      // Se elimina el codigo de recuperacion para que no sea reutilizable
      await _supabase.from('codigorecuperacion').delete().eq('correo', correo);
    } catch (e) {
      throw Exception('No se pudo cambiar la contraseña: $e');
    }
  }

  // ── ACTUALIZAR PERFIL ──────────────────────────────────────────────────────
  // Modifica los datos del usuario existente y actualiza la sesion local
  static Future<void> actualizarPerfil({
    required String correo,
    required String nombre,
    required int edad,
    required double peso,
    required double estatura,
    String? avatarUrl,
  }) async {
    try {
      // Creacion de un mapa dinamico para enviar solo los campos necesarios a la DB
      final Map<String, dynamic> updates = {
        'nombre': nombre,
        'edad': edad,
        'weight': peso, // Nota: Asegurate de que el nombre sea 'peso' en tu DB
        'height':
            estatura, // Nota: Asegurate de que el nombre sea 'estatura' en tu DB
      };

      // Si se subio una nueva imagen, se añade la URL al mapa de actualizacion
      if (avatarUrl != null) {
        updates['avatar_url'] = avatarUrl;
      }

      await _supabase.from('usuario').update(updates).eq('correo', correo);

      // Sincronizacion de SharedPreferences con los nuevos valores de perfil
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', nombre);
      await prefs.setString('userPeso', peso.toString());
      await prefs.setString('userEstatura', estatura.toString());

      if (avatarUrl != null) {
        await prefs.setString('userAvatar', avatarUrl);
      }
    } catch (e) {
      throw Exception('Error al actualizar el perfil: $e');
    }
  }
}
