import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';

class CambioContrasenaScreen extends StatefulWidget {
  final String correo;
  final String codigo;

  const CambioContrasenaScreen({
    super.key,
    required this.correo,
    required this.codigo,
  });

  @override
  State<CambioContrasenaScreen> createState() => _CambioContrasenaScreenState();
}

class _CambioContrasenaScreenState extends State<CambioContrasenaScreen> {
  final _nuevaPasswordController = TextEditingController();
  final _confirmarPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF33D1C1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Cambiar Contraseña",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Para: ${widget.correo}",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // CAMPO: NUEVA CONTRASEÑA
                TextFormField(
                  controller: _nuevaPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Nueva contraseña',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Ingrese la contraseña';
                    if (value.length < 8)
                      return 'Mínimo 8 caracteres'; // REQUISITO 8 CARACTERES
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // CAMPO: CONFIRMAR CONTRASEÑA
                TextFormField(
                  controller: _confirmarPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Confirmar contraseña',
                    prefixIcon: Icon(Icons.lock_reset),
                  ),
                  validator: (value) {
                    if (value != _nuevaPasswordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 60),

                SizedBox(
                  width: 140,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            // Validamos el formulario antes de procesar
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isLoading = true);
                              try {
                                await AuthController.cambiarContrasena(
                                  widget.correo,
                                  widget.codigo,
                                  _nuevaPasswordController.text.trim(),
                                );

                                if (!mounted) return;

                                // MENSAJE DE ÉXITO
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Contraseña actualizada con éxito',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                // Regresa al Login (primera pantalla)
                                Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                );
                              } catch (e) {
                                // MENSAJE DE ERROR
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              } finally {
                                if (mounted) setState(() => _isLoading = false);
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Cambiar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
