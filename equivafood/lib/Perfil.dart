import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'api_service.dart';
import 'Restricciones.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();
  final _pesoController = TextEditingController();
  final _estaturaController = TextEditingController();

  String _correoUsuario = '';
  String? _avatarUrl;
  File? _imageFile;
  bool _isLoading = false;
  bool _isLoadingData = true;

  Set<String> _restricciones = {};
  bool _preferencia = true; 

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _pesoController.dispose();
    _estaturaController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatosUsuario() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _correoUsuario = prefs.getString('userEmail') ?? '';

      if (_correoUsuario.isNotEmpty) {
        final data = await Supabase.instance.client
            .from('usuario')
            .select()
            .eq('correo', _correoUsuario)
            .single();

        setState(() {
          _nombreController.text = (data['nombre'] ?? '').toString();
          _edadController.text = (data['edad'] ?? '').toString();
          _pesoController.text = (data['peso'] ?? '').toString();
          _estaturaController.text = (data['estatura'] ?? '').toString();
          _avatarUrl = data['avatar_url'];

          _preferencia = data['preferencia'] ?? true; 

          // Cargar las restricciones de SharedPreferences de forma segura
          final listRestricciones = prefs.getStringList('restricciones') ?? [];
          _restricciones = listRestricciones.toSet();

          _isLoadingData = false;
        });
      }
    } catch (e) {
      setState(() => _isLoadingData = false);
      debugPrint('Error cargando datos del perfil: $e');
    }
  }

  Future<void> _seleccionarImagen() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Sincroniza localmente y envía a la base de datos remota en tiempo real
  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      final int edadFormateada = int.tryParse(_edadController.text.trim()) ?? 0;
      final double pesoFormateado =
          double.tryParse(_pesoController.text.trim()) ?? 0.0;
      final double estaturaFormateada =
          double.tryParse(_estaturaController.text.trim()) ?? 0.0;

      String? nuevaAvatarUrl = _avatarUrl;
      if (_imageFile != null) {
        nuevaAvatarUrl = await ApiService.subirImagen(
          _imageFile!,
          _correoUsuario,
        );
      }

      // ── GUARDADO DIRECTO A LA COLUMNA DE TEXTO EN SUPABASE ──
      await Supabase.instance.client
          .from('usuario')
          .update({
            'nombre': _nombreController.text.trim(),
            'edad': edadFormateada,
            'peso': pesoFormateado,
            'estatura': estaturaFormateada,
            'avatar_url': nuevaAvatarUrl,
            'restricciones': _restricciones.toList().toString(), // Guardado seguro compatible con columna text
            'preferencia': _preferencia, 
          })
          .eq('correo', _correoUsuario);

      // ── PERSISTENCIA LOCAL ──
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('restricciones', _restricciones.toList());
      await prefs.setBool('preferencia', _preferencia); 
      if (nuevaAvatarUrl != null) {
        await prefs.setString('userAvatar', nuevaAvatarUrl);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Perfil y preferencias actualizadas en la nube!'),
          backgroundColor: Color(0xFF33D1C1),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF33D1C1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _seleccionarImagen,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : (_avatarUrl != null && _avatarUrl!.isNotEmpty)
                                ? NetworkImage(_avatarUrl!)
                                : const AssetImage('assets/default_avatar.png') as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: primaryColor,
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35),

                    TextFormField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre Completo',
                        prefixIcon: const Icon(Icons.person_outline, color: primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Ingresa tu nombre' : null,
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _edadController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Edad (años)',
                        prefixIcon: const Icon(Icons.cake_outlined, color: primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Ingresa tu edad' : null,
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _pesoController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Peso (kg)',
                              prefixIcon: const Icon(Icons.scale_outlined, color: primaryColor),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                            ),
                            validator: (v) => v == null || v.isEmpty ? 'Ingresa tu peso' : null,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            controller: _estaturaController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Estatura (m)',
                              prefixIcon: const Icon(Icons.straighten_outlined, color: primaryColor),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                            ),
                            validator: (v) => v == null || v.isEmpty ? 'Ingresa tu estatura' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    const Divider(),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Restricciones y Preferencias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 15),

                    RestriccionesWidget(
                      seleccionadas: _restricciones,
                      preferencia: _preferencia, 
                      onRestriccionesChanged: (v) => setState(() => _restricciones = v),
                      onPreferenciaChanged: (v) => setState(() => _preferencia = v), 
                    ),
                    
                    const SizedBox(height: 35),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _guardarCambios,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 3,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Guardar Cambios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}