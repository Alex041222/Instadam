import 'package:flutter/material.dart';
import '../../datos/modelos/publicacion.dart';
import '../../datos/modelos/usuario.dart';
import '../../datos/bd/like_dao.dart';
import '../../datos/bd/comentario_dao.dart';
import '../../servicios/servicio_autenticacion.dart';
import 'dart:io';
import '../pantallas/pantalla_comentarios.dart';
import 'package:intl/intl.dart';

class TarjetaPublicacion extends StatefulWidget {
  final Publicacion publicacion;
  final Usuario usuario;
  final VoidCallback? onRefresh;

  const TarjetaPublicacion({
    super.key,
    required this.publicacion,
    required this.usuario,
    this.onRefresh,
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Has tret el m'agrada")),
      );
    } else {
      await _likeDAO.darLike(idUsu, idPub);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Has donat m'agrada")),
      );
    }

    await _cargarEstado();
    widget.onRefresh?.call();
  }

  Future<void> _abrirComentarios() async {
    final resultat = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaComentarios(publicacion: widget.publicacion),
      ),
    );

    if (resultat == true) {
      await _cargarEstado();
      widget.onRefresh?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Semantics(
            label: "Ver perfil de ${widget.usuario.nombre}",
            button: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.usuario.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Publicat el: ${DateFormat('HH:mm dd/MM/yyyy').format(widget.publicacion.fecha)}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),

          if (widget.publicacion.rutaImagen.isNotEmpty)
            Semantics(
              label: "Abrir publicación",
              button: true,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.file(
                  File(widget.publicacion.rutaImagen),
                  fit: BoxFit.contain,
                ),
              ),
            ),

          const SizedBox(height: 10),

          Row(
            children: [

              // LIKE ACCESSIBLE
              Semantics(
                label: haDadoLike
                    ? "M'agrada activat. $totalLikes m'agrades."
                    : "M'agrada desactivat. $totalLikes m'agrades.",
                toggled: haDadoLike,
                onTapHint: haDadoLike
                    ? "Tocar per treure m'agrada"
                    : "Tocar per donar m'agrada",
                button: true,
                child: IconButton(
                  icon: Icon(
                    haDadoLike ? Icons.favorite : Icons.favorite_border,
                    color: haDadoLike ? Colors.red : Colors.black,
                  ),
                  onPressed: _toggleLike,
                ),
              ),

              Text("$totalLikes m'agrades"),

              const SizedBox(width: 20),

              // COMENTAR ACCESSIBLE
              Semantics(
                label: "Obrir comentaris. $totalComentarios comentaris.",
                button: true,
                child: IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: _abrirComentarios,
                ),
              ),

              // 🔥 AIXÒ FALTAVA
              Text("$totalComentarios comentaris"),
            ],
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.publicacion.descripcion,
              style: const TextStyle(fontSize: 16),
            ),
          ),

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
