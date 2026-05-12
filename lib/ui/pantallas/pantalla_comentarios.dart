import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../datos/modelos/publicacion.dart';
import '../../datos/modelos/comentario.dart';
import '../../servicios/servicio_autenticacion.dart';
import '../../servicios/servicio_firestore.dart';

class PantallaComentarios extends StatefulWidget {
  final Publicacion publicacion;

  const PantallaComentarios({super.key, required this.publicacion});

  @override
  State<PantallaComentarios> createState() => _PantallaComentariosState();
}

class _PantallaComentariosState extends State<PantallaComentarios> {
  final _control = TextEditingController();

  Future<void> _enviarComentario() async {
    final texto = _control.text.trim();
    if (texto.isEmpty) return;

    final usuario = ServicioAutenticacion.instancia.usuarioActual!;
    final nuevo = Comentario(
      idPublicacion: widget.publicacion.id!,
      uidAutor: usuario.id!,
      nombreUsuario: usuario.nombre,
      texto: texto,
      fecha: DateTime.now(),
    );

    try {
      await ServicioFirestore.instancia.afegirComentari(nuevo);
      _control.clear();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comentari afegit")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comentaris"),
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Comentario>>(
              stream: ServicioFirestore.instancia.obtenerComentarios(widget.publicacion.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final comentarios = snapshot.data ?? [];

                if (comentarios.isEmpty) {
                  return const Center(child: Text("Encara no hi ha comentaris."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 10),
                  itemCount: comentarios.length,
                  itemBuilder: (_, i) {
                    final c = comentarios[i];
                    final hora = DateFormat('HH:mm dd/MM/yyyy').format(c.fecha);

                    return MergeSemantics(
                      child: ListTile(
                        leading: ExcludeSemantics(
                          child: const CircleAvatar(child: Icon(Icons.person)),
                        ),
                        title: Text(c.nombreUsuario),
                        subtitle: Text("${c.texto}\n$hora"),
                      ),
                    );
                  },
                );
              }
            ),
          ),

          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      label: "Escriure comentari",
                      child: TextField(
                        controller: _control,
                        decoration: const InputDecoration(
                          hintText: "Escriu un comentari...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Semantics(
                    label: "Enviar comentari",
                    button: true,
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _enviarComentario,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
