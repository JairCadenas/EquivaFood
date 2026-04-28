import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'PlanAlimenticio.dart';
import 'Perfil.dart';
import 'Ayuda.dart';

// Se cambia a StatefulWidget para permitir el redibujo de la interfaz
// cuando el usuario regrese de la pantalla de perfil tras actualizar sus datos.
class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  // Metodo para disparar el rediseño de la pantalla.
  // Al llamar a setState, el FutureBuilder vuelve a ejecutar la peticion a Supabase.
  void _refrescarDatos() {
    setState(() {});
  }

  // Obtiene los datos actualizados del usuario desde la base de datos de Supabase.
  // Se utiliza el correo guardado en SharedPreferences como identificador unico.
  Future<Map<String, dynamic>> _getDatosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('userEmail');

    if (email == null) throw Exception("Sesion no encontrada");

    final data = await Supabase.instance.client
        .from('usuario')
        .select()
        .eq('correo', email)
        .single();

    return data;
  }

  // Elimina los datos locales y redirige al usuario a la pantalla de login.
  Future<void> _cerrarSesion(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF33D1C1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/Logo.png',
              height: 40,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.fastfood, color: primaryColor),
            ),
            const SizedBox(width: 10),
            const Text(
              'EquivaFood',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getDatosUsuario(),
        builder: (context, snapshot) {
          // Manejo del estado de carga de la peticion asincrona.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          // Manejo de errores en caso de fallo de red o consulta.
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final user = snapshot.data!;
          // Recuperacion de la URL de imagen guardada en la columna avatar_url.
          final String? avatarUrl = user['avatar_url'];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Seccion de encabezado con informacion de perfil.
                Row(
                  children: [
                    GestureDetector(
                      // Se captura el resultado de la navegacion. Si la pantalla de perfil
                      // retorna 'true' al cerrarse, se actualiza la pantalla principal.
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PerfilScreen(),
                          ),
                        );
                        if (result == true) _refrescarDatos();
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFFF5F5F5),
                        // Carga la imagen desde la red si la URL existe en la base de datos.
                        // En caso contrario, no se asigna imagen de fondo para mostrar el child.
                        backgroundImage:
                            (avatarUrl != null && avatarUrl.isNotEmpty)
                            ? NetworkImage(avatarUrl)
                            : null,
                        // Muestra un icono de marcador de posicion si no hay imagen de perfil.
                        child: (avatarUrl == null || avatarUrl.isEmpty)
                            ? const Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 35,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['nombre'] ?? 'Usuario',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Peso: ${user['peso']} kg  Altura: ${user['estatura']} cm',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Botones de acceso rapido a otras funciones del sistema.
                    _buildIconBtn(
                      context,
                      Icons.menu_book,
                      primaryColor,
                      const PlanAlimenticioScreen(),
                    ),
                    _buildIconBtn(
                      context,
                      Icons.help_outline,
                      primaryColor,
                      const AyudaScreen(),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.power_settings_new,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => _cerrarSesion(context),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Comidas del Día:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15),
                // Lista de tarjetas para el seguimiento de la dieta.
                _mealCard("Desayuno"),
                _mealCard("Colación"),
                _mealCard("Comida"),
                _mealCard("Colación"),
                _mealCard("Cena"),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper para construir botones de iconos con navegacion asincrona para refresco.
  Widget _buildIconBtn(
    BuildContext context,
    IconData icon,
    Color color,
    Widget screen,
  ) {
    return IconButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
        if (result == true) _refrescarDatos();
      },
      icon: Icon(icon, color: color, size: 24),
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  // Helper para construir las tarjetas visuales de las comidas.
  Widget _mealCard(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          const Icon(Icons.restaurant_menu, color: Colors.black26),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Toca la flecha para ver alternativas',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
        ],
      ),
    );
  }
}
