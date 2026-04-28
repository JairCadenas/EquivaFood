import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'PlanAlimenticio.dart';
import 'Perfil.dart';
import 'Ayuda.dart';

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  Future<Map<String, dynamic>> _getDatosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('userEmail');

    if (email == null) throw Exception("Sesión no encontrada");

    final data = await Supabase.instance.client
        .from('usuario')
        .select()
        .eq('correo', email)
        .single();

    return data;
  }

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
        // ✅ CAMBIO: Ahora usamos el Logo.png en lugar del icono de balanza
        title: Row(
          children: [
            Image.asset(
              'assets/Logo.png',
              height: 40, // Ajusta el tamaño según necesites
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // --- CABECERA DE USUARIO ---
                Row(
                  children: [
                    // ✅ CAMBIO: La imagen de perfil ahora es un botón que lleva a Perfil.dart
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PerfilScreen()),
                      ),
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFFF5F5F5),
                        child: Icon(Icons.person, color: Colors.grey, size: 35),
                        // Nota: Cuando implementes la subida de imagen,
                        // aquí usarás NetworkImage con la URL de Supabase
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
                    // ICONOS DE NAVEGACIÓN SUPERIOR
                    _buildIconBtn(
                      context,
                      Icons.menu_book,
                      primaryColor,
                      const PlanAlimenticioScreen(),
                    ),
                    _buildIconBtn(
                      context,
                      Icons.person_outline,
                      primaryColor,
                      const PerfilScreen(),
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

  Widget _buildIconBtn(
    BuildContext context,
    IconData icon,
    Color color,
    Widget screen,
  ) {
    return IconButton(
      onPressed: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      icon: Icon(icon, color: color, size: 24),
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

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
