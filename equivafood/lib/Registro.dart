import 'package:flutter/material.dart';
import 'api_service.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  // Controladores
  final _nombreController    = TextEditingController();
  final _edadController      = TextEditingController();
  final _pesoController      = TextEditingController();
  final _estaturaController  = TextEditingController();
  final _correoController    = TextEditingController();
  final _passwordController  = TextEditingController();

  final _formKey   = GlobalKey<FormState>();
  bool _isLoading  = false;

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

  // ── FUNCIÓN DE REGISTRO ──────────────────────────────────────────────────────
  Future<void> _handleRegistro() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.registro(
        nombre:   _nombreController.text.trim(),
        edad:     int.parse(_edadController.text.trim()),
        peso:     double.parse(_pesoController.text.trim()),
        estatura: double.parse(_estaturaController.text.trim()),
        correo:   _correoController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      // ✅ Registro exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Cuenta creada! Bienvenido, ${result['nombre']}'),
          backgroundColor: const Color(0xFF33D1C1),
        ),
      );

      // Regresa al login después del registro
      Navigator.pop(context);

    } catch (e) {
      if (!mounted) return;

      // ❌ Error de registro
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

  // ── HELPER: Campo de texto reutilizable ──────────────────────────────────────
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
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) return 'Este campo es requerido';
            return null;
          },
    );
  }

  // ── BUILD ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF33D1C1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 50),

                // --- ICONO DE PERFIL ---
                const Center(
                  child: Icon(
                    Icons.account_circle,
                    size: 130,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 40),

                // --- NOMBRE ---
                _buildField(
                  controller: _nombreController,
                  hint: 'Nombre completo',
                ),

                const SizedBox(height: 20),

                // --- CORREO ---
                _buildField(
                  controller: _correoController,
                  hint: 'Correo electrónico (nombre de usuario)',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingresa tu correo';
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) return 'Correo no válido';
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // --- CONTRASEÑA ---
                _buildField(
                  controller: _passwordController,
                  hint: 'Contraseña',
                  obscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingresa una contraseña';
                    if (value.length < 4) return 'Mínimo 4 caracteres';
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // --- EDAD, PESO, ESTATURA en una fila ---
                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        controller: _edadController,
                        hint: 'Edad',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Requerido';
                          if (int.tryParse(value) == null) return 'Número entero';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildField(
                        controller: _pesoController,
                        hint: 'Peso (kg)',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Requerido';
                          if (double.tryParse(value) == null) return 'Número válido';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildField(
                        controller: _estaturaController,
                        hint: 'Estatura (m)',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Requerido';
                          if (double.tryParse(value) == null) return 'Número válido';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // --- BOTONES ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // REGRESAR
                    SizedBox(
                      width: 140,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'Regresar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // CREAR
                    SizedBox(
                      width: 140,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleRegistro,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 3,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Crear',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
