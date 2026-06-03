import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/api_service.dart';

class Planalimenticio extends StatefulWidget {
  const Planalimenticio({super.key});

  @override
  State<Planalimenticio> createState() => _PlanalimenticioState();
}

class _PlanalimenticioState extends State<Planalimenticio> {
  bool _isUploading = false;
  bool _isLoadingStatus = true;
  String? _pdfUrl;

  @override
  void initState() {
    super.initState();
    _verificarPlanExistente();
  }

  // Verifica si el usuario ya tiene un PDF guardado en Supabase
  Future<void> _verificarPlanExistente() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? email = prefs.getString('userEmail');
      if (email != null) {
        final data = await Supabase.instance.client
            .from('usuario')
            .select('plan_pdf_url')
            .eq('correo', email)
            .single();
        setState(() {
          _pdfUrl = data['plan_pdf_url'];
          _isLoadingStatus = false;
        });
      }
    } catch (e) {
      setState(() => _isLoadingStatus = false);
    }
  }

  // Abre el selector de archivos PDF y lo sube a Supabase Storage
  Future<void> _subirArchivo() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() => _isUploading = true);
      try {
        final prefs = await SharedPreferences.getInstance();
        final correo = prefs.getString('userEmail') ?? '';
        final url = await ApiService.subirPlanPDF(
          correo: correo,
          file: result.files.first,
        );
        if (!mounted) return;
        setState(() {
          _pdfUrl = url;
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Plan actualizado correctamente."),
            backgroundColor: Colors.green,
          ),
        );
        // Regresa true para que PantallaPrincipal se refresque
        Navigator.pop(context, true);
      } catch (e) {
        setState(() => _isUploading = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF33D1C1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Mi Plan Alimenticio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoadingStatus
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.picture_as_pdf,
                    size: 100,
                    color: _pdfUrl != null ? Colors.green : primaryColor,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _pdfUrl != null
                        ? "¡Plan ya configurado!"
                        : "Aún no has subido tu plan",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    child: Text(
                      _pdfUrl != null
                          ? "Ya tienes un plan alimenticio activo. Puedes subir uno nuevo si tu dieta ha cambiado."
                          : "Sube tu documento PDF para que EquivaFood analice tus tiempos de comida y te ofrezca alternativas.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _isUploading
                      ? const CircularProgressIndicator(color: primaryColor)
                      : ElevatedButton.icon(
                          onPressed: _subirArchivo,
                          icon: const Icon(
                            Icons.upload_file,
                            color: Colors.white,
                          ),
                          label: Text(
                            _pdfUrl != null
                                ? "Actualizar mi PDF"
                                : "Seleccionar PDF",
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
