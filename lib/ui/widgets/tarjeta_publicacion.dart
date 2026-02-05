import 'package:flutter/material.dart';
import '../../datos/modelos/publicacion.dart';
import '../../datos/modelos/usuario.dart';
import '../../datos/bd/like_dao.dart';
import '../../datos/bd/comentario_dao.dart';
import '../../servicios/servicio_autenticacion.dart';
import 'dart:io';
import '../pantallas/pantalla_comentarios.dart';

class TarjetaPublicacion extends StatefulWidget {
  final Publicacion publicacion;
  final Usuario usuario;

  const TarjetaPublicacion({
    super.key,
    required this.publicacion,
    required this.usuario,
  });

  @override
  State<TarjetaPublicacion> createState() => _TarjetaPublicacionState();
}

class _TarjetaPublicacionState extends State<TarjetaPublicacion> {
  bool haDadoLike = false;
  int totalLikes = 0;
  int totalComentarios = 0;
  String? ultimoComentarioTexto;

  final _likeDAO = LikeDAO();
  final _comentarioDAO = ComentarioDAO();

  @override
  void initState() {
    super.initState();
    _cargarEstado();
  }

  Future<void> _cargarEstado() async {
    final usuarioActual = ServicioAutenticacion.instancia.usuarioActual!;
    final idUsu = usuarioActual.id!;
    final idPub = widget.publicacion.id!;

    final haLike = await _likeDAO.usuarioHaDadoLike(idUsu, idPub);
    final likes = await _likeDAO.contarLikesDePublicacion(idPub);
    final comentarios = await _comentarioDAO.contarComentariosDePublicacion(idPub);
    final ultimo = await _comentarioDAO.obtenerUltimoComentario(idPub);

    if (!mounted) return;
    setState(() {
      haDadoLike = haLike;
      totalLikes = likes;
      totalComentarios = comentarios;
      ultimoComentarioTexto = ultimo?.texto;
    });
  }

  Future<void> _toggleLike() async {
    final usuarioActual = ServicioAutenticacion.instancia.usuarioActual!;
    final idUsu = usuarioActual.id!;
    final idPub = widget.publicacion.id!;

    if (haDadoLike) {
      await _likeDAO.quitarLike(idUsu, idPub);
    } else {
      await _likeDAO.darLike(idUsu, idPub);
    }

    await _cargarEstado();
  }

  Future<void> _abrirComentarios() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaComentarios(publicacion: widget.publicacion),
      ),
    );

    await _cargarEstado();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre del usuario
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.usuario.nombre,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          // Imagen completa sin recortes
          if (widget.publicacion.rutaImagen.isNotEmpty)
            AspectRatio(
              aspectRatio: 1,
              child: Image.file(
                File(widget.publicacion.rutaImagen),
                fit: BoxFit.contain,
              ),
            ),

          const SizedBox(height: 10),

          // Likes + comentarios
          Row(
            children: [
              IconButton(
                icon: Icon(
                  haDadoLike ? Icons.favorite : Icons.favorite_border,
                  color: haDadoLike ? Colors.red : Colors.black,
                ),
                onPressed: _toggleLike,
              ),
              Text("$totalLikes likes"),

              const SizedBox(width: 20),

              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: _abrirComentarios,
              ),
              Text("$totalComentarios comentarios"),
            ],
          ),

          const SizedBox(height: 10),

          // Descripción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.publicacion.descripcion,
              style: const TextStyle(fontSize: 16),
            ),
          ),

          // Último comentario
          if (ultimoComentarioTexto != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                ultimoComentarioTexto!,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
