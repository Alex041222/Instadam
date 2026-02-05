import 'package:flutter/material.dart';
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
    await _cargarComentarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comentarios")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _comentarios.length,
              itemBuilder: (_, i) {
                final c = _comentarios[i];
                return ListTile(
                  title: Text(c.nombreUsuario),
                  subtitle: Text(c.texto),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _control,
                    decoration: const InputDecoration(
                      hintText: "Escribe un comentario...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _enviarComentario,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
