import 'package:flutter/material.dart';
import '../../datos/modelos/publicacion.dart';
import '../../datos/modelos/usuario.dart';
import '../../servicios/servicio_autenticacion.dart';
import '../../servicios/servicio_firestore.dart';
import 'dart:io';
import '../pantallas/pantalla_comentarios.dart';
import 'package:intl/intl.dart';

class TarjetaPublicacion extends StatefulWidget {
  final Publicacion publicacion;
  final Usuario? usuario; // Opcional si ja ve del feed
  final VoidCallback? onRefresh;

  const TarjetaPublicacion({
    super.key,
    required this.publicacion,
    this.usuario,
    this.onRefresh,
  });

  @override
  State<TarjetaPublicacion> createState() => _TarjetaPublicacionState();
}

class _TarjetaPublicacionState extends State<TarjetaPublicacion> {
  bool haDadoLike = false;
  int totalLikes = 0;
  int totalComentarios = 0;

  @override
  void initState() {
    super.initState();
    _actualizarEstado();
  }

  @override
  void didUpdateWidget(TarjetaPublicacion oldWidget) {
    super.didUpdateWidget(oldWidget);
    _actualizarEstado();
  }

  void _actualizarEstado() {
    final usuarioActual = ServicioAutenticacion.instancia.usuarioActual;
    if (usuarioActual != null) {
      haDadoLike = widget.publicacion.likes.contains(usuarioActual.id);
    }
    totalLikes = widget.publicacion.likes.length;
    totalComentarios = widget.publicacion.comentariosCount;
  }

  Future<void> _toggleLike() async {
    final usuarioActual = ServicioAutenticacion.instancia.usuarioActual;
    if (usuarioActual == null) return;

    await ServicioFirestore.instancia.alternarLike(
      widget.publicacion.id!,
      usuarioActual.id!,
    );
    
    // El feed s'actualitzarà via Stream, però podem fer feedback local si volem
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(haDadoLike ? "Has donat m'agrada" : "Has tret el m'agrada"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _abrirComentarios() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaComentarios(publicacion: widget.publicacion),
      ),
    );
    // L'actualització vindrà pel Stream de Firestore
  }

  @override
  Widget build(BuildContext context) {
    final nomAutor = widget.usuario?.nombre ?? widget.publicacion.nombreAutor;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Semantics(
            label: "Ver perfil de $nomAutor",
            button: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                nomAutor,
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
              label: "Imatge de la publicació de $nomAutor",
              button: true,
              child: AspectRatio(
                aspectRatio: 1,
                child: _construirImagen(widget.publicacion.rutaImagen),
              ),
            ),

          const SizedBox(height: 10),

          Row(
            children: [

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

              Semantics(
                label: "Obrir comentaris. $totalComentarios comentaris.",
                button: true,
                child: IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: _abrirComentarios,
                ),
              ),

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

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _construirImagen(String ruta) {
    if (ruta.startsWith('http')) {
      return Image.network(ruta, fit: BoxFit.contain);
    }
    final file = File(ruta);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.contain);
    }
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.image, size: 50),
    );
  }
}
