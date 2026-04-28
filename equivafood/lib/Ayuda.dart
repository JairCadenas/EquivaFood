import 'package:flutter/material.dart';

class AyudaScreen extends StatelessWidget {
  const AyudaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF33D1C1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Centro de Ayuda',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preguntas Frecuentes',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Resuelve tus dudas rápidamente sobre el uso de EquivaFood.',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 30),

            // --- BLOQUE DE PREGUNTAS ---
            _buildFAQItem(
              '¿Cómo puedo cambiar mi contraseña?',
              'Si no puedes acceder, usa la opción "¿Olvidé mi contraseña?" en la pantalla de inicio. Si ya iniciaste sesión, pronto habilitaremos un botón de cambio directo en tu perfil.',
              primaryColor,
            ),
            _buildFAQItem(
              '¿Cómo modificar mis datos personales?',
              'Toca tu foto o el icono de usuario en la pantalla principal para ir a tu Perfil. Allí podrás actualizar tu nombre, peso y estatura para recalcular tus equivalencias.',
              primaryColor,
            ),
            _buildFAQItem(
              '¿Cuánto tarda el código de verificación?',
              'El envío es casi instantáneo (menos de 1 minuto). Si no llega, revisa tu carpeta de Spam. Recuerda que el código tiene una validez de 15 minutos.',
              primaryColor,
            ),
            _buildFAQItem(
              '¿Cómo subir mi plan alimentario?',
              'Debes dirigirte a la sección "Plan Alimenticio" (icono de agenda). En esa pantalla encontrarás la opción para cargar el documento o los datos que tu nutricionista te proporcionó.',
              primaryColor,
            ),
            _buildFAQItem(
              '¿Para qué sirve la flecha en las comidas?',
              'Es el corazón de EquivaFood. Al tocarla, el sistema te ofrecerá alternativas de alimentos equivalentes por si no tienes lo que indica tu plan original.',
              primaryColor,
            ),

            const SizedBox(height: 40),

            // --- SECCIÓN DE CONTACTO FINAL ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: primaryColor.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.alternate_email,
                    color: primaryColor,
                    size: 35,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '¿Todavía necesitas apoyo?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Si tu consulta es técnica o específica, escríbenos a:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),

                  // Correo seleccionable para copiar fácilmente
                  SelectableText(
                    'naruhina0818@gmail.com',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Horario de atención: Lunes a Viernes',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Constructor de los elementos desplegables (FAQ)
  Widget _buildFAQItem(String pregunta, String respuesta, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: ExpansionTile(
        title: Text(
          pregunta,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        iconColor: color,
        collapsedIconColor: Colors.grey,
        childrenPadding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        shape: const Border(), // Elimina bordes extraños al expandir
        children: [
          Text(
            respuesta,
            style: const TextStyle(
              color: Colors.black54,
              height: 1.5,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
