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
    if (_imagen == null || _descripcionController.text.isEmpty) return;

    final usuario = ServicioAutenticacion.instancia.usuarioActual!;

    final nueva = Publicacion(
      id: null,
      idUsuario: usuario.id!,
      descripcion: _descripcionController.text,
      rutaImagen: _imagen!.path,
      likes: 0,
      comentarios: 0,
      fecha: DateTime.now(),
    );

    await PublicacionDAO().insertarPublicacion(nueva);

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _seleccionarImagen,
              child: const Text("Seleccionar imagen"),
            ),

            const SizedBox(height: 20),

            if (_imagen != null)
              Image.file(_imagen!, height: 200, fit: BoxFit.cover),

            const SizedBox(height: 20),

            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: "Descripción"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _publicar,
              child: const Text("Publicar"),
            ),
          ],
        ),
      ),
    );
  }
}
