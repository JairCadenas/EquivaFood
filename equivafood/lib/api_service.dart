import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final _supabase = Supabase.instance.client;

  // Cambiamos a getters para asegurar que lean el .env en tiempo real
  static String get _usuarioCorreo => dotenv.get('SMTP_EMAIL', fallback: '');
  static String get _passwordApp => dotenv.get('SMTP_PASSWORD', fallback: '');

  // ── INICIO DE SESIÓN ──────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> login({
    required String correo,
    required String password,
  }) async {
    try {
      final data = await _supabase
          .from('usuario')
          .select()
          .eq('correo', correo)
          .eq('password', password)
          .maybeSingle();

      if (data == null) {
        throw Exception('Correo o contraseña incorrectos');
      }

      return data;
    } catch (e) {
      throw Exception('Error en el login: $e');
    }
  }

  // ── REGISTRO DE USUARIO ───────────────────────────────────────────────────
  static Future<Map<String, dynamic>> registro({
    required String nombre,
    required int edad,
    required double peso,
    required double estatura,
    required String correo,
    required String password,
    String planAlimentario = 'Sin plan',
  }) async {
    try {
      final response = await _supabase.from('usuario').insert({
        'nombre': nombre,
        'edad': edad,
        'peso': peso,
        'estatura': estatura,
        'correo': correo,
        'password': password,
        'planalimentario': planAlimentario,
      }).select();

      return response.first;
    } catch (e) {
      throw Exception('Error al registrar: $e');
    }
  }

  // ── RECUPERACIÓN DE CONTRASEÑA ─────────────────────────────────────────────
  static Future<void> enviarCodigoRecuperacion({required String correo}) async {
    try {
      // 1. Generar código de 6 dígitos
      final String codigo = (100000 + (DateTime.now().microsecond % 900000))
          .toString();

      // 2. Guardar en Supabase
      await _supabase.from('codigorecuperacion').upsert({
        'correo': correo,
        'codigo': codigo,
        'expira_en': DateTime.now()
            .add(const Duration(minutes: 15))
            .toIso8601String(),
      });

      // 3. Configurar SMTP (Usando los getters que leen el .env)
      if (_usuarioCorreo.isEmpty || _passwordApp.isEmpty) {
        throw Exception('Credenciales SMTP no configuradas en el .env');
      }

      final smtpServer = gmail(_usuarioCorreo, _passwordApp);

      // 4. Crear mensaje
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

      // 5. Enviar
      await send(message, smtpServer);
    } catch (e) {
      throw Exception('No se pudo enviar el código: $e');
    }
  }

  // ── VERIFICAR CÓDIGO ──────────────────────────────────────────────────────
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
      if (DateTime.now().isAfter(expiraEn)) {
        throw Exception('El código ha expirado');
      }
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ── CAMBIAR CONTRASEÑA FINAL ──────────────────────────────────────────────
  static Future<void> cambiarContrasena({
    required String correo,
    required String codigo,
    required String nuevaPassword,
  }) async {
    try {
      // Primero verificamos que el código siga siendo válido
      await verificarCodigo(correo: correo, codigo: codigo);

      // Actualizamos la contraseña del usuario
      await _supabase
          .from('usuario')
          .update({'password': nuevaPassword})
          .eq('correo', correo);

      // Borramos el código usado para que no se use de nuevo
      await _supabase.from('codigorecuperacion').delete().eq('correo', correo);
    } catch (e) {
      throw Exception('No se pudo cambiar la contraseña: $e');
    }
  }
}
