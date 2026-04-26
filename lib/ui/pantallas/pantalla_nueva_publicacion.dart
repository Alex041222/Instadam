import 'package:flutter/material.dart';
import '../../datos/bd/publicacion_dao.dart';
import '../../servicios/servicio_autenticacion.dart';
import '../../datos/modelos/publicacion.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PantallaNuevaPublicacion extends StatefulWidget {
  const PantallaNuevaPublicacion({super.key});

  @override
  State<PantallaNuevaPublicacion> createState() => _PantallaNuevaPublicacionState();
}

class _PantallaNuevaPublicacionState extends State<PantallaNuevaPublicacion> {
  File? _imagen;
  bool _publicando = false;
  String? _errorDescripcion;

  final TextEditingController _descripcionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _seleccionarImagen() async {
    final XFile? imagenSeleccionada =
    await _picker.pickImage(source: ImageSource.gallery);

    if (imagenSeleccionada != null) {
      setState(() {
        _imagen = File(imagenSeleccionada.path);
      });
    }
  }

  Future<void> _publicar() async {
    setState(() {
      _errorDescripcion = null;
    });

    if (_imagen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Has de seleccionar una imatge"),
        ),
      );
      return;
    }

    if (_descripcionController.text.trim().isEmpty) {
      setState(() {
        _errorDescripcion = "La descripció és obligatòria";
      });
      return;
    }

    setState(() {
      _publicando = true;
    });

    final usuario = ServicioAutenticacion.instancia.usuarioActual!;

    final nueva = Publicacion(
      id: null,
      idUsuario: usuario.id!,
      descripcion: _descripcionController.text.trim(),
      rutaImagen: _imagen!.path,
      likes: 0,
      comentarios: 0,
      fecha: DateTime.now(),
    );

    await PublicacionDAO().insertarPublicacion(nueva);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Publicació creada correctament"),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔥 SELECTOR D'IMATGE AMB ESTAT ACCESSIBLE
            Semantics(
              label: _imagen == null
                  ? "Seleccionar imatge. Cap imatge seleccionada."
                  : "Seleccionar imatge. Imatge seleccionada.",
              button: true,
              child: ElevatedButton(
                onPressed: _publicando ? null : _seleccionarImagen,
                child: const Text("Seleccionar imatge"),
              ),
            ),

            const SizedBox(height: 20),

            if (_imagen != null)
              Semantics(
                label: "Imatge seleccionada",
                image: true,
                child: Image.file(
                  _imagen!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 30),

            // 🔥 ETIQUETA VISIBLE + CAMP OBLIGATORI
            const Text(
              "Descripció (obligatori)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            Semantics(
              label: "Camp de descripció, obligatori",
              child: TextField(
                controller: _descripcionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Escriu una descripció...",
                  errorText: _errorDescripcion,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🔥 BOTÓ PUBLICAR AMB ESTAT DE CÀRREGA
            Semantics(
              label: _publicando ? "Publicant..." : "Publicar publicació",
              button: true,
              child: ElevatedButton(
                onPressed: _publicando ? null : _publicar,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: _publicando
                    ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(width: 12),
                    Text("Publicant..."),
                  ],
                )
                    : const Text("Publicar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
