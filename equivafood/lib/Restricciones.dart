import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── MODELO ────────────────────────────────────────────────────────────────────
class RestriccionItem {
  final String tag;
  final String label;
  final IconData icono;
  final String categoria;

  const RestriccionItem({
    required this.tag,
    required this.label,
    required this.icono,
    required this.categoria,
  });
}

// ── CATÁLOGO GLOBAL (compartido entre pantallas) ──────────────────────────────
const List<RestriccionItem> catalogoRestricciones = [
  RestriccionItem(tag: 'nuez',    label: 'Frutos secos',    icono: Icons.spa_outlined,        categoria: 'Alergias'),
  RestriccionItem(tag: 'gluten',  label: 'Gluten',           icono: Icons.grain,               categoria: 'Alergias'),
  RestriccionItem(tag: 'lacteo',  label: 'Lácteos',          icono: Icons.water_drop_outlined, categoria: 'Alergias'),
  RestriccionItem(tag: 'huevo',   label: 'Huevo',            icono: Icons.egg_outlined,        categoria: 'Alergias'),
  RestriccionItem(tag: 'soya',    label: 'Soya',             icono: Icons.eco_outlined,        categoria: 'Alergias'),
  RestriccionItem(tag: 'pescado', label: 'Mariscos/Pescado', icono: Icons.set_meal_outlined,   categoria: 'Alergias'),
  RestriccionItem(tag: 'carne',   label: 'Sin carne roja',   icono: Icons.no_meals_outlined,   categoria: 'Preferencias'),
];

// ══════════════════════════════════════════════════════════════════════════════
// WIDGET REUTILIZABLE — usado en Registro.dart y Perfil.dart
// ══════════════════════════════════════════════════════════════════════════════
class RestriccionesWidget extends StatefulWidget {
  final Set<String> seleccionadas;
  final bool preferencia; // CORREGIDO: cambiado de preferenciaCarne a preferencia
  final void Function(Set<String>) onRestriccionesChanged;
  final void Function(bool) onPreferenciaChanged; // CORREGIDO

  const RestriccionesWidget({
    super.key,
    required this.seleccionadas,
    required this.preferencia, // CORREGIDO
    required this.onRestriccionesChanged,
    required this.onPreferenciaChanged, // CORREGIDO
  });

  @override
  State<RestriccionesWidget> createState() => _RestriccionesWidgetState();
}

class _RestriccionesWidgetState extends State<RestriccionesWidget> {
  late Set<String> _seleccionadas;
  late bool _preferencia; // CORREGIDO

  @override
  void initState() {
    super.initState();
    _seleccionadas = Set.from(widget.seleccionadas);
    _preferencia = widget.preferencia; // CORREGIDO
  }

  void _toggleTag(String tag) {
    setState(() {
      _seleccionadas.contains(tag) ? _seleccionadas.remove(tag) : _seleccionadas.add(tag);
    });
    widget.onRestriccionesChanged(_seleccionadas);
  }

  void _setDieta(bool carne) {
    setState(() => _preferencia = carne); // CORREGIDO
    widget.onPreferenciaChanged(carne); // CORREGIDO
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF33D1C1);
    final categorias = catalogoRestricciones.map((e) => e.categoria).toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tipo de dieta', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _dietaCard(label: 'Omnívora', sublabel: 'Incluye carne y pescado',
                icono: Icons.restaurant, seleccionado: _preferencia, // CORREGIDO
                onTap: () => _setDieta(true), color: primaryColor)),
            const SizedBox(width: 12),
            Expanded(child: _dietaCard(label: 'Vegetal', sublabel: 'Sin carne ni pescado',
                icono: Icons.eco, seleccionado: !_preferencia, // CORREGIDO
                onTap: () => _setDieta(false), color: Colors.green)),
          ],
        ),
        const SizedBox(height: 20),
        ...categorias.map((categoria) {
          final items = catalogoRestricciones.where((e) => e.categoria == categoria).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(categoria, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: items.map((item) {
                  final activo = _seleccionadas.contains(item.tag);
                  return GestureDetector(
                    onTap: () => _toggleTag(item.tag),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: activo ? Colors.redAccent.withOpacity(0.1) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: activo ? Colors.redAccent : Colors.grey.shade300, width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(item.icono, size: 16, color: activo ? Colors.redAccent : Colors.grey),
                          const SizedBox(width: 5),
                          Text(item.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                              color: activo ? Colors.redAccent : Colors.black87)),
                          if (activo) ...[const SizedBox(width: 4), const Icon(Icons.close, size: 12, color: Colors.redAccent)],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
            ],
          );
        }),
      ],
    );
  }

  Widget _dietaCard({required String label, required String sublabel, required IconData icono,
      required bool seleccionado, required VoidCallback onTap, required Color color}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: seleccionado ? color.withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: seleccionado ? color : Colors.grey.shade300, width: 2),
        ),
        child: Column(
          children: [
            Icon(icono, size: 28, color: seleccionado ? color : Colors.grey),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: seleccionado ? color : Colors.black87, fontSize: 13)),
            const SizedBox(height: 3),
            Text(sublabel, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            if (seleccionado) Padding(padding: const EdgeInsets.only(top: 6), child: Icon(Icons.check_circle, color: color, size: 18)),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// PANTALLA COMPLETA — accesible desde PantallaPrincipal
// ══════════════════════════════════════════════════════════════════════════════
class RestriccionesScreen extends StatefulWidget {
  const RestriccionesScreen({super.key});
  @override
  State<RestriccionesScreen> createState() => _RestriccionesScreenState();
}

class _RestriccionesScreenState extends State<RestriccionesScreen> {
  Set<String> _seleccionadas = {};
  bool _preferencia = true; // CORREGIDO
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _cargarPreferencias(); }

  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _seleccionadas = (prefs.getStringList('restricciones') ?? []).toSet();
      _preferencia = prefs.getBool('preferencia') ?? true; // CORREGIDO: clave local
      _isLoading = false;
    });
  }

  Future<void> _guardar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('restricciones', _seleccionadas.toList());
    await prefs.setBool('preferencia', _preferencia); // CORREGIDO
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Preferencias guardadas'), backgroundColor: Color(0xFF33D1C1)));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF33D1C1);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Restricciones Alimenticias', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: primaryColor, foregroundColor: Colors.white, elevation: 0),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: primaryColor.withOpacity(0.08), borderRadius: BorderRadius.circular(14)),
                    child: const Row(children: [
                      Icon(Icons.info_outline, color: Color(0xFF33D1C1)),
                      SizedBox(width: 10),
                      Expanded(child: Text('Tus alternativas del menú se ajustarán automáticamente según estas preferencias.', style: TextStyle(fontSize: 13))),
                    ]),
                  ),
                  const SizedBox(height: 22),
                  RestriccionesWidget(
                    seleccionadas: _seleccionadas,
                    preferencia: _preferencia, // CORREGIDO
                    onRestriccionesChanged: (v) => setState(() => _seleccionadas = v),
                    onPreferenciaChanged: (v) => setState(() => _preferencia = v), // CORREGIDO
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity, height: 55,
                    child: ElevatedButton.icon(
                      onPressed: _guardar,
                      icon: const Icon(Icons.save_outlined, color: Colors.white),
                      label: const Text('Guardar preferencias', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), elevation: 3),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}