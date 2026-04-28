import 'dart:io'; // 1. Añadido para manejar el archivo de imagen
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 2. Añadido para elegir la foto
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'api_service.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();
  final _pesoController = TextEditingController();
  final _estaturaController = TextEditingController();

  String _correoUsuario = '';
  String? _avatarUrl; // 3. Variable para la URL de Supabase
  File? _imageFile; // 4. Variable para la foto nueva seleccionada
  bool _isLoading = false;
  bool _isLoadingData = true;

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

  // Cargar los datos actuales desde Supabase para mostrarlos en los campos
  Future<void> _cargarDatosUsuario() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _correoUsuario = prefs.getString('userEmail') ?? '';

      if (_correoUsuario.isEmpty) throw Exception('No hay sesión activa');

      final data = await Supabase.instance.client
          .from('usuario')
          .select()
          .eq('correo', _correoUsuario)
          .single();

      setState(() {
        _nombreController.text = data['nombre'] ?? '';
        _edadController.text = data['edad']?.toString() ?? '';
        _pesoController.text = data['peso']?.toString() ?? '';
        _estaturaController.text = data['estatura']?.toString() ?? '';
        _avatarUrl =
            data['avatar_url']; // 5. Cargamos la URL de la imagen si existe
        _isLoadingData = false;
      });
    } catch (e) {
      setState(() => _isLoadingData = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar datos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 6. Nuevo método para seleccionar la imagen de la galería
  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Guardar los cambios realizados
  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 7. Lógica de subida de imagen
      String? nuevaUrl = _avatarUrl;
      if (_imageFile != null) {
        nuevaUrl = await ApiService.subirImagen(_imageFile!, _correoUsuario);
      }

      await ApiService.actualizarPerfil(
        correo: _correoUsuario,
        nombre: _nombreController.text.trim(),
        edad: int.parse(_edadController.text.trim()),
        peso: double.parse(_pesoController.text.trim().replaceAll(',', '.')),
        estatura: double.parse(
          _estaturaController.text.trim().replaceAll(',', '.'),
        ),
        avatarUrl: nuevaUrl, // 8. Pasamos la URL al ApiService
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF33D1C1)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF33D1C1), width: 2),
          ),
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Requerido' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF33D1C1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 9. Modificamos el CircleAvatar para que sea interactivo
                    GestureDetector(
                      onTap: _seleccionarImagen,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: const Color(0xFFF5F5F5),
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!) // Si eligió una nueva
                                : (_avatarUrl != null
                                      ? NetworkImage(
                                          _avatarUrl!,
                                        ) // Si ya tenía una en Supabase
                                      : null),
                            child: (_imageFile == null && _avatarUrl == null)
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _correoUsuario,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 30),

                    // Campos de texto
                    _buildField(
                      controller: _nombreController,
                      label: 'Nombre completo',
                      icon: Icons.badge_outlined,
                    ),
                    _buildField(
                      controller: _edadController,
                      label: 'Edad',
                      icon: Icons.cake_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    _buildField(
                      controller: _pesoController,
                      label: 'Peso (kg)',
                      icon: Icons.monitor_weight_outlined,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    _buildField(
                      controller: _estaturaController,
                      label: 'Estatura (cm/m)',
                      icon: Icons.height_outlined,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Botón de guardar
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _guardarCambios,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 3,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Guardar Cambios',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
