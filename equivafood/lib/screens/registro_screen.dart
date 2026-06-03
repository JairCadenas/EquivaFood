import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../restricciones.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();
  final _pesoController = TextEditingController();
  final _estaturaController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Set<String> _restricciones = {};
  bool _preferencia = true; // CORREGIDO: nombre unificado

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _pesoController.dispose();
    _estaturaController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _handleREGISTRO() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String? avatarUrl;

      if (_imageFile != null) {
        avatarUrl = await ApiService.subirImagen(
          _imageFile!,
          _correoController.text.trim().toLowerCase(),
        );
      }

      final result = await ApiService.registro(
        nombre: _nombreController.text.trim(),
        edad: int.parse(_edadController.text.trim()),
        peso: double.parse(_pesoController.text.trim().replaceAll(',', '.')),
        estatura: double.parse(
          _estaturaController.text.trim().replaceAll(',', '.'),
        ),
        correo: _correoController.text.trim().toLowerCase(),
        password: _passwordController.text.trim(),
        avatarUrl: avatarUrl,
        restricciones: _restricciones.toList(),
        preferencia:
            _preferencia, // CORREGIDO: variable unificada hacia ApiService
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Cuenta creada! Bienvenido, ${result['nombre']}'),
          backgroundColor: const Color(0xFF33D1C1),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF33D1C1)),
        ),
      ),
      validator:
          validator ??
          (value) => (value == null || value.isEmpty) ? 'Requerido' : null,
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
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _seleccionarImagen,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : null,
                    child: _imageFile == null
                        ? const Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                "Crear Nueva Cuenta".TextM(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 30),

                _buildField(
                  controller: _nombreController,
                  hint: 'Nombre completo',
                ),
                const SizedBox(height: 15),

                _buildField(
                  controller: _correoController,
                  hint: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Ingresa tu correo';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                      return 'Correo no válido';
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                _buildField(
                  controller: _passwordController,
                  hint: 'Contraseña',
                  obscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Ingresa una contraseña';
                    if (value.length < 8) return 'Mínimo 8 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        controller: _edadController,
                        hint: 'Edad',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Requerido';
                          final edad = int.tryParse(value);
                          if (edad == null) return 'Número inválido';
                          if (edad < 1) return 'Mín. 1 año';
                          if (edad > 120) return 'Máx. 120 años';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildField(
                        controller: _pesoController,
                        hint: 'Peso (kg)',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Requerido';
                          final peso = double.tryParse(
                            value.replaceAll(',', '.'),
                          );
                          if (peso == null) return 'Número inválido';
                          if (peso < 1) return 'Mín. 1 kg';
                          if (peso > 635) return 'Máx. 635 kg';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildField(
                        controller: _estaturaController,
                        hint: 'Estatura (m)',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Requerido';
                          final val = double.tryParse(
                            value.replaceAll(',', '.'),
                          );
                          if (val == null) return 'Número inválido';
                          if (val < 0.5 && val > 0) return 'Mín. 0.5 m';
                          if (val > 2.72 && val <= 10) return 'Máx. 2.72 m';
                          if (val > 10 && val < 50) return 'Usa m (ej: 1.70)';
                          if (val > 272) return 'Máx. 272 cm';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  'Restricciones alimenticias',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Opcional — puedes modificarlas después en tu perfil.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 14),
                RestriccionesWidget(
                  seleccionadas: _restricciones,
                  preferencia: _preferencia, // CORREGIDO: variable unificada
                  onRestriccionesChanged: (v) =>
                      setState(() => _restricciones = v),
                  onPreferenciaChanged: (v) =>
                      setState(() => _preferencia = v), // CORREGIDO
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleREGISTRO,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Registrarme',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on String {
  Widget TextM({double? fontSize, FontWeight? fontWeight}) {
    return Text(
      this,
      style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
