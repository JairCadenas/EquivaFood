import 'dart:io';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class ApiService {
  // Cliente de Supabase para realizar peticiones a la base de datos y al storage
  static final _supabase = Supabase.instance.client;

  // Getters para recuperar las credenciales de correo desde el archivo .env
  static String get _usuarioCorreo => dotenv.get('SMTP_EMAIL', fallback: '');
  static String get _passwordApp => dotenv.get('SMTP_PASSWORD', fallback: '');

  // ── SUBIR IMAGEN DE PERFIL A STORAGE ─────────────────────────────────────
  static Future<String?> subirImagen(File imageFile, String email) async {
    try {
      final String fileName =
          'avatar_${email}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await _supabase.storage
          .from('avatars')
          .upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl = _supabase.storage
          .from('avatars')
          .getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      print('Error en ApiService.subirImagen: $e');
      return null;
    }
  }

  // ── INICIO DE SESIÓN (Fiel a tus variables originales de sesión) ─────────
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

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userName', data['nombre'] ?? 'Usuario');
      await prefs.setString('userEmail', data['correo'] ?? '');
      await prefs.setString('userPeso', data['peso']?.toString() ?? '0');
      await prefs.setString(
        'userEstatura',
        data['estatura']?.toString() ?? '0',
      );

      if (data['avatar_url'] != null) {
        await prefs.setString('userAvatar', data['avatar_url']);
      }

      // ── RECONSTRUCCIÓN ROBUSTA DE RESTRICCIONES ──
      List<String> restricciones = [];
      final rawRestricciones = data['restricciones'];

      if (rawRestricciones != null) {
        if (rawRestricciones is List) {
          restricciones = rawRestricciones.map((e) => e.toString()).toList();
        } else if (rawRestricciones is String) {
          final cleanStr = rawRestricciones
              .replaceAll('[', '')
              .replaceAll(']', '')
              .trim();
          if (cleanStr.isNotEmpty) {
            restricciones = cleanStr.split(',').map((e) => e.trim()).toList();
          }
        }
      }

      await prefs.setStringList('restricciones', restricciones);
      await prefs.setBool('preferencia', data['preferencia'] ?? true);

      return data;
    } catch (e) {
      throw Exception('Error en el login: $e');
    }
  }

  // ── REGISTRO DE USUARIO (Mantiene exactamente tus parámetros originales) ──
  static Future<Map<String, dynamic>> registro({
    required String nombre,
    required int edad,
    required double peso,
    required double estatura,
    required String correo,
    required String password,
    String? planAlimentario,
    String? avatarUrl,
    List<String> restricciones = const [],
    bool preferencia = true,
  }) async {
    try {
      // Sincronización transparente: Transforma la lista de Dart a un Array compatible con Postgre
      final response = await _supabase.from('usuario').insert({
        'nombre': nombre,
        'edad': edad,
        'peso': peso,
        'estatura': estatura,
        'correo': correo,
        'password': password,
        'plan_pdf_url': null, // Vinculado a tu base de datos real
        'avatar_url': avatarUrl,
        'restricciones': restricciones, // Guardado nativo sin romper tipos
        'preferencia': preferencia,
      }).select();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('restricciones', restricciones);
      await prefs.setBool('preferencia', preferencia);

      return response.first;
    } catch (e) {
      throw Exception('Error al registrar: $e');
    }
  }

  // ── RECUPERACIÓN DE CONTRASEÑA (Corregido 'creado_en' e 'expira_en') ──────
  static Future<void> enviarCodigoRecuperacion({required String correo}) async {
    try {
      // Validación previa de existencia de usuario
      final usuario = await _supabase
          .from('usuario')
          .select()
          .eq('correo', correo)
          .maybeSingle();

      if (usuario == null) {
        throw Exception('El correo electrónico no está registrado.');
      }

      final String codigo =
          (100000 + (DateTime.now().microsecondsSinceEpoch % 900000))
              .toString();

      // Upsert adaptado a las columnas correctas de la tabla
      await _supabase.from('codigorecuperacion').upsert({
        'correo': correo,
        'codigo': codigo,
        'expira_en': DateTime.now()
            .add(const Duration(minutes: 15))
            .toIso8601String(),
      }, onConflict: 'correo');

      if (_usuarioCorreo.isEmpty || _passwordApp.isEmpty) {
        throw Exception('Credenciales SMTP no configuradas en el .env');
      }

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

  // ── VERIFICAR CÓDIGO (Corregida la ordenación por 'creado_en') ───────────
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
          .order('creado_en', ascending: false)
          .limit(1);

      if (res.isEmpty) throw Exception('Código incorrecto o no solicitado');

      final registro = res.first;
      final expiraEn = DateTime.parse(registro['expira_en']);
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
      await verificarCodigo(correo: correo, codigo: codigo);
      await _supabase
          .from('usuario')
          .update({'password': nuevaPassword})
          .eq('correo', correo);

      await _supabase.from('codigorecuperacion').delete().eq('correo', correo);
    } catch (e) {
      throw Exception('No se pudo cambiar la contraseña: $e');
    }
  }

  // ── ACTUALIZAR PERFIL (Mantiene tus firmas y mapeos locales exactos) ─────
  static Future<void> actualizarPerfil({
    required String correo,
    required String nombre,
    required int edad,
    required double peso,
    required double estatura,
    String? avatarUrl,
    List<String>? restricciones,
    bool? preferencia,
  }) async {
    try {
      final Map<String, dynamic> updates = {
        'nombre': nombre,
        'edad': edad,
        'peso': peso,
        'estatura': estatura,
      };

      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (restricciones != null) updates['restricciones'] = restricciones;
      if (preferencia != null) updates['preferencia'] = preferencia;

      await _supabase.from('usuario').update(updates).eq('correo', correo);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', nombre);
      await prefs.setString('userPeso', peso.toString());
      await prefs.setString('userEstatura', estatura.toString());
      if (avatarUrl != null) await prefs.setString('userAvatar', avatarUrl);
      if (restricciones != null)
        await prefs.setStringList('restricciones', restricciones);
      if (preferencia != null) await prefs.setBool('preferencia', preferencia);
    } catch (e) {
      throw Exception('Error al actualizar el perfil: $e');
    }
  }

  // ── GESTIÓN DE PDF DEL PLAN ALIMENTICIO ───────────────────────────────────
  static Future<String?> subirPlanPDF({
    required String correo,
    required PlatformFile file,
  }) async {
    try {
      final fileName =
          'plan_${correo}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      if (file.bytes != null) {
        await _supabase.storage
            .from('planes_alimenticios')
            .uploadBinary(
              fileName,
              file.bytes!,
              fileOptions: const FileOptions(
                contentType: 'application/pdf',
                upsert: true,
              ),
            );
      } else {
        await _supabase.storage
            .from('planes_alimenticios')
            .upload(
              fileName,
              File(file.path!),
              fileOptions: const FileOptions(
                contentType: 'application/pdf',
                upsert: true,
              ),
            );
      }

      final String publicUrl = _supabase.storage
          .from('planes_alimenticios')
          .getPublicUrl(fileName);

      await _supabase
          .from('usuario')
          .update({'plan_pdf_url': publicUrl})
          .eq('correo', correo);

      return publicUrl;
    } catch (e) {
      throw Exception('Error al subir PDF: $e');
    }
  }

  // ── LÓGICA DE EQUIVALENCIAS ALIMENTICIAS ──────────────────────────────────
  static Map<String, String> obtenerPlanOriginal(
    String tiempoComida,
    String dia,
  ) {
    final Map<String, Map<String, String>> planPDFActual = {
      "Lun": {
        "Desayuno": "Huevo revuelto con espinacas (0.120 kg + 0.050 kg)",
        "Colación": "Manzana verde (0.150 kg)",
        "Comida":
            "Pechuga de pollo a la plancha con quinoa (0.150 kg + 0.100 kg)",
        "Cena": "Atún en agua con ensalada verde (0.100 kg + 0.150 kg)",
      },
      "Mar": {
        "Desayuno":
            "Avena con leche de almendras y fresas (0.040 kg + 0.250 l + 0.080 kg)",
        "Colación": "Nueces de la india (0.025 kg)",
        "Comida":
            "Filete de pescado blanco con brócoli al vapor (0.180 kg + 0.150 kg)",
        "Cena": "Tacos de lechuga con pavo molido (0.120 kg + 0.080 kg)",
      },
      "Mie": {
        "Desayuno": "Omelette de claras con champiñones (0.150 l + 0.060 kg)",
        "Colación": "Pera madura (0.160 kg)",
        "Comida": "Carne de res magra con arroz integral (0.140 kg + 0.080 kg)",
        "Cena": "Sopa de verduras clara (0.350 l)",
      },
      "Jue": {
        "Desayuno":
            "Batido de proteína con plátano (0.300 l + 0.030 kg + 0.080 kg)",
        "Colación": "Zanahorias baby (0.100 kg)",
        "Comida": "Salmón al horno con espárragos (0.150 kg + 0.120 kg)",
        "Cena": "Pechuga de pavo con aguacate (0.100 kg + 0.050 kg)",
      },
      "Vie": {
        "Desayuno": "Pan integral tostado con requesón (0.060 kg + 0.050 kg)",
        "Colación": "Papaya picada (0.180 kg)",
        "Comida": "Tostadas de pollo (0.130 kg + 2 pzas tostadas)",
        "Cena": "Ensalada de garbanzos y pepino (0.080 kg + 0.120 kg)",
      },
      "Sab": {
        "Desayuno": "Hot cakes de avena y clara de huevo (0.050 kg + 0.100 l)",
        "Colación": "Melón chino (0.200 kg)",
        "Comida": "Bistec de res con nopales asados (0.150 kg + 0.150 kg)",
        "Cena":
            "Quesadilla de tortilla de maíz y queso panela (1 pza + 0.040 kg)",
      },
      "Dom": {
        "Desayuno":
            "Chilaquiles verdes ligeros (0.040 kg totopo + 0.080 kg pollo)",
        "Colación": "Toronja en gajos (0.180 kg)",
        "Comida":
            "Pechuga de pollo rellena de calabacita (0.160 kg + 0.070 kg)",
        "Cena":
            "Sándwich de pan integral y jamón de pavo (2 reb pan + 0.060 kg)",
      },
    };

    final String claveDia = planPDFActual.containsKey(dia) ? dia : "Lun";
    final Map<String, String> comidasDeHoy = planPDFActual[claveDia]!;

    return {
      "nombre": comidasDeHoy[tiempoComida] ?? "Alimento asignado en PDF",
      "info": "Cantidades y gramos de tu documento oficial",
    };
  }

  static final Map<String, List<Map<String, dynamic>>> _banco = {
    "Desayuno": [
      {
        "nombre": "Omelette de 2 claras con champiñones",
        "info": "Equivalente: 1 Proteína + 1 Verdura",
        "tags": ["huevo"],
      },
      {
        "nombre": "Yogurt Griego con 5 almendras",
        "info": "Equivalente: 1 Proteína + 1 Grasa",
        "tags": ["lacteo", "nuez"],
      },
      {
        "nombre": "2 Huevos cocidos con espinacas",
        "info": "Equivalente: 1 Proteína + 1 Verdura",
        "tags": ["huevo"],
      },
      {
        "nombre": "Queso Panela asado (60g) con nopal",
        "info": "Equivalente: 1 Proteína + 1 Fibra",
        "tags": ["lacteo"],
      },
      {
        "nombre": "Avena con leche de almendra y fruta",
        "info": "Equivalente: 1 Carb + 1 Grasa",
        "tags": ["gluten", "nuez"],
      },
      {
        "nombre": "Tostadas de arroz con aguacate",
        "info": "Equivalente: 1 Carb + 1 Grasa",
        "tags": [],
      },
      {
        "nombre": "Tofu revuelto con espinacas",
        "info": "Equivalente: 1 Proteína + 1 Verdura",
        "tags": ["soya"],
      },
      {
        "nombre": "Licuado de proteína vegetal con plátano",
        "info": "Equivalente: 1 Proteína + 1 Fruta",
        "tags": ["soya"],
      },
      {
        "nombre": "Chilaquiles con salsa verde (sin queso)",
        "info": "Equivalente: 1 Carb + 1 Verdura",
        "tags": ["gluten"],
      },
      {
        "nombre": "Hotcakes de avena con miel",
        "info": "Equivalente: 1.5 Carb",
        "tags": ["gluten", "huevo", "lacteo"],
      },
    ],
    "Colación": [
      {
        "nombre": "10 mitades de nuez",
        "info": "Equivalente: 1 Grasa",
        "tags": ["nuez"],
      },
      {
        "nombre": "1 Taza de Jícama con limón",
        "info": "Equivalente: Libre",
        "tags": [],
      },
      {"nombre": "1 Pera pequeña", "info": "Equivalente: 1 Fruta", "tags": []},
      {"nombre": "1 Gelatina light", "info": "Equivalente: Libre", "tags": []},
      {
        "nombre": "Pepino con chile y limón",
        "info": "Equivalente: Libre",
        "tags": [],
      },
      {
        "nombre": "Edamame (1/2 taza)",
        "info": "Equivalente: 1 Proteína",
        "tags": ["soya"],
      },
      {
        "nombre": "Zanahoria con hummus",
        "info": "Equivalente: 1 Verdura + 1 Grasa",
        "tags": [],
      },
      {
        "nombre": "1 Manzana con mantequilla de maní",
        "info": "Equivalente: 1 Fruta + 1 Grasa",
        "tags": ["nuez"],
      },
      {
        "nombre": "Galletas de arroz con aguacate",
        "info": "Equivalente: 1 Carb + 1 Grasa",
        "tags": [],
      },
      {
        "nombre": "Mix de semillas (girasol, chía)",
        "info": "Equivalente: 1 Grasa",
        "tags": [],
      },
    ],
    "Comida": [
      {
        "nombre": "Filete de Pescado (120g) al vapor",
        "info": "Equivalente: 1.5 Proteína",
        "tags": ["pescado"],
      },
      {
        "nombre": "Carne de res magra (100g) asada",
        "info": "Equivalente: 1.5 Proteína",
        "tags": ["carne"],
      },
      {
        "nombre": "Tacos de pechuga de pavo (3 pzas)",
        "info": "Equivalente: 1.5 Proteína + Carbohidrato",
        "tags": ["carne", "gluten"],
      },
      {
        "nombre": "Salmón a la plancha con espárragos",
        "info": "Equivalente: 2 Proteínas + Fibra",
        "tags": ["pescado"],
      },
      {
        "nombre": "Lentejas guisadas con verduras",
        "info": "Equivalente: 1.5 Proteína + 1 Carb",
        "tags": [],
      },
      {
        "nombre": "Fajitas de tofu con pimientos",
        "info": "Equivalente: 1.5 Proteína + 1 Verdura",
        "tags": ["soya"],
      },
      {
        "nombre": "Sopa de garbanzo con espinacas",
        "info": "Equivalente: 1 Proteína + 1 Verdura",
        "tags": [],
      },
      {
        "nombre": "Pechuga de pollo a la plancha (120g)",
        "info": "Equivalente: 1.5 Proteína",
        "tags": ["carne"],
      },
      {
        "nombre": "Atún en agua con ensalada (120g)",
        "info": "Equivalente: 1.5 Proteína",
        "tags": ["pescado"],
      },
      {
        "nombre": "Hamburguesa de frijol negro",
        "info": "Equivalente: 1.5 Proteína + 1 Carb",
        "tags": ["gluten"],
      },
      {
        "nombre": "Camarones salteados con verduras",
        "info": "Equivalente: 1.5 Proteína + 1 Verdura",
        "tags": ["pescado"],
      },
      {
        "nombre": "Tempeh al ajillo con brócoli",
        "info": "Equivalente: 1.5 Proteína + 1 Verdura",
        "tags": ["soya"],
      },
    ],
    "Cena": [
      {
        "nombre": "Sándwich de pan integral con pavo",
        "info": "Equivalente: 1 Carbohidrato + 1 Proteína",
        "tags": ["carne", "gluten"],
      },
      {
        "nombre": "Quesadilla con tortilla de maíz (1 pza)",
        "info": "Equivalente: 1 Carbohidrato + 1 Proteína",
        "tags": ["lacteo"],
      },
      {
        "nombre": "Taza de cereal de fibra con leche light",
        "info": "Equivalente: 1 Carb + 0.5 Proteína",
        "tags": ["gluten", "lacteo"],
      },
      {
        "nombre": "Rollitos de jamón con queso cottage",
        "info": "Equivalente: 1 Proteína + Lácteo",
        "tags": ["carne", "lacteo"],
      },
      {
        "nombre": "Sopa de verduras con tofu",
        "info": "Equivalente: 1 Proteína + 1 Verdura",
        "tags": ["soya"],
      },
      {
        "nombre": "Wrap vegetal con hummus y espinacas",
        "info": "Equivalente: 1 Carb + 1 Grasa",
        "tags": ["gluten"],
      },
      {
        "nombre": "Crema de elote light",
        "info": "Equivalente: 1 Carb",
        "tags": [],
      },
      {
        "nombre": "Tostadas de frijol con nopal asado",
        "info": "Equivalente: 1 Carb + 1 Proteína",
        "tags": [],
      },
      {
        "nombre": "Ensalada de garbanzos con pepino",
        "info": "Equivalente: 1 Proteína + Libre",
        "tags": [],
      },
      {
        "nombre": "Tortilla de maíz con aguacate y jitomate",
        "info": "Equivalente: 1 Carb + 1 Grasa",
        "tags": [],
      },
    ],
  };

  static List<Map<String, String>> obtenerEquivalentes(
    String tiempoComida,
    String dia, {
    List<String> restricciones = const [],
    bool preferencia = true,
    int cantidad = 3,
  }) {
    final todos = _banco[tiempoComida] ?? [];
    final tagsExcluir = [...restricciones];
    if (!preferencia) tagsExcluir.addAll(['carne', 'pescado']);

    final filtrados = todos.where((item) {
      final tags = List<String>.from(item['tags'] as List);
      return !tags.any((tag) => tagsExcluir.contains(tag));
    }).toList();

    final fuente = filtrados.isEmpty ? todos : filtrados;
    fuente.shuffle(Random());

    return fuente
        .take(cantidad)
        .map(
          (item) => {
            "nombre": item["nombre"] as String,
            "info": item["info"] as String,
          },
        )
        .toList();
  }
}
