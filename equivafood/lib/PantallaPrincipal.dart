import 'package:flutter/material.dart';

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EquivaFood - Inicio'),
        backgroundColor: const Color(0xFF33D1C1),
      ),
      body: const Center(
        child: Text(
          '¡Bienvenido a tu Pantalla Principal!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
