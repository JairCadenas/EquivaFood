import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'PlanAlimenticio.dart';
import 'Perfil.dart';
import 'Ayuda.dart';
import 'api_service.dart';

// Definicion de la pantalla principal como StatefulWidget para permitir la
// actualizacion de la UI tras realizar cambios en el perfil del usuario.
class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  // Selector de día de la semana (0 = Lunes, 6 = Domingo)
  int _diaSeleccionado = DateTime.now().weekday - 1;
  final List<String> _dias = ["Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom"];
  // Metodo para forzar la reconstruccion del widget.
  void _refrescarDatos() {
    setState(() {});
  }

  // Realiza una peticion asincrona a Supabase para obtener la informacion del usuario.
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

  // Finaliza la sesion eliminando los datos de SharedPreferences.
  Future<void> _cerrarSesion(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final user = snapshot.data!;
          final String? avatarUrl = user['avatar_url'];
          // Verificar si el usuario ya tiene su PDF subido
          final bool tienePlan =
              user['plan_pdf_url'] != null &&
              user['plan_pdf_url'].toString().isNotEmpty;

          // SafeArea + SingleChildScrollView para evitar overflow en pantallas pequeñas
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // --- SECCION: CABECERA DE USUARIO ---
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const Perfil()),
                            );
                            if (result == true) _refrescarDatos();
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xFFF5F5F5),
                            backgroundImage:
                                (avatarUrl != null && avatarUrl.isNotEmpty)
                                ? NetworkImage(avatarUrl)
                                : null,
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
                        _buildIconBtn(
                          context,
                          Icons.menu_book,
                          primaryColor,
                          const Planalimenticio(),
                        ),
                        _buildIconBtn(
                          context,
                          Icons.person_outline,
                          primaryColor,
                          const Perfil(),
                        ),
                        _buildIconBtn(
                          context,
                          Icons.help_outline,
                          primaryColor,
                          const Ayuda(),
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

                    const SizedBox(height: 25),

                    // --- SELECTOR DE DÍAS DE LA SEMANA ---
                    const Text(
                      'Día de la semana:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _buildSelectorDias(primaryColor),
                    const SizedBox(height: 15),

                    const Text(
                      'Comidas del Día:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // --- TARJETAS DE COMIDA CON ALTERNATIVAS ---
                    _mealCard("Desayuno", tienePlan),
                    const SizedBox(height: 12),
                    _mealCard("Colación", tienePlan),
                    const SizedBox(height: 12),
                    _mealCard("Comida", tienePlan),
                    const SizedBox(height: 12),
                    _mealCard("Colación", tienePlan),
                    const SizedBox(height: 12),
                    _mealCard("Cena", tienePlan),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
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

  // Selector horizontal de días de la semana
  Widget _buildSelectorDias(Color color) {
    return Container(
      height: 65,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dias.length,
        itemBuilder: (context, index) {
          bool esHoy = index == _diaSeleccionado;
          return GestureDetector(
            onTap: () => setState(() => _diaSeleccionado = index),
            child: Container(
              width: 55,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: esHoy ? color : Colors.white,
                border: Border.all(color: esHoy ? color : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _dias[index],
                    style: TextStyle(
                      color: esHoy ? Colors.white : Colors.black87,
                      fontWeight: esHoy ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (esHoy)
                    Container(
                      height: 5,
                      width: 5,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Tarjeta de comida con ExpansionTile para mostrar alternativas equivalentes
  Widget _mealCard(String title, bool tienePlan) {
    final original = ApiService.obtenerPlanOriginal(
      title,
      _dias[_diaSeleccionado],
    );
    final alternativas = ApiService.obtenerEquivalentes(
      title,
      _dias[_diaSeleccionado],
    );

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: const Color(0xFF33D1C1),
          leading: const Icon(Icons.restaurant_menu, color: Colors.black26),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            tienePlan
                ? "Original: ${original['nombre']}"
                : "Sube tu PDF para ver tu dieta",
            style: TextStyle(
              fontSize: 12,
              color: tienePlan ? Colors.black54 : Colors.redAccent,
            ),
          ),
          children: tienePlan
              ? [
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Alternativas Sugeridas:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF33D1C1),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  ...alternativas
                      .map(
                        (eq) => ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.swap_horiz,
                            color: Color(0xFF33D1C1),
                            size: 18,
                          ),
                          title: Text(
                            eq['nombre']!,
                            style: const TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            eq['info']!,
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 8),
                ]
              : [
                  const ListTile(
                    title: Text(
                      "Ve a 'Mi Plan Alimenticio' para subir tu dieta.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
