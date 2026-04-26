import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../datos/modelos/publicacion.dart';
import '../../datos/modelos/comentario.dart';
import '../../datos/bd/comentario_dao.dart';
import '../../servicios/servicio_autenticacion.dart';

class PantallaComentarios extends StatefulWidget {
  final Publicacion publicacion;

  const PantallaComentarios({super.key, required this.publicacion});

  @override
  State<PantallaComentarios> createState() => _PantallaComentariosState();
}

class _PantallaComentariosState extends State<PantallaComentarios> {
  final _dao = ComentarioDAO();
  final _control = TextEditingController();
  List<Comentario> _comentarios = [];

  @override
  void initState() {
    super.initState();
    _cargarComentarios();
  }

  Future<void> _cargarComentarios() async {
    final lista = await _dao.obtenerComentariosDePublicacion(widget.publicacion.id!);
    if (!mounted) return;
    setState(() {
      _comentarios = lista;
    });
  }

  Future<void> _enviarComentario() async {
    final texto = _control.text.trim();
    if (texto.isEmpty) return;

    final usuario = ServicioAutenticacion.instancia.usuarioActual!;
    final nuevo = Comentario(
      idPublicacion: widget.publicacion.id!,
      nombreUsuario: usuario.nombre,
      texto: texto,
      fecha: DateTime.now(),
    );

    await _dao.insertarComentario(nuevo);
    _control.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Comentari afegit")),
    );

    // Actualitza la llista local
    await _cargarComentarios();

    // 🔥 Torna al feed i força refresc del comptador
    Navigator.pop(context, true);
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
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 10),
              itemCount: _comentarios.length,
              itemBuilder: (_, i) {
                final c = _comentarios[i];
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
            ),
          ),

          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
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
