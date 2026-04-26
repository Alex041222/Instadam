import 'package:flutter/material.dart';
import 'dart:io';
import '../pantallas/pantalla_comentarios.dart';
import '../../datos/modelos/publicacion.dart';
import '../../datos/modelos/comentario.dart';

class PostCard extends StatefulWidget {
  final Publicacion publicacion;
  final String autor;
  final String temps;
  final String descripcio;
  final String altImatge;
  final String urlImatge;
  final int likesInicials;
  final int comentaris;
  final Comentario? ultimComentari;
  final VoidCallback? onRefresh;

  const PostCard({
    super.key,
    required this.publicacion,
    required this.autor,
    required this.temps,
    required this.descripcio,
    required this.altImatge,
    required this.urlImatge,
    required this.likesInicials,
    required this.comentaris,
    this.ultimComentari,
    this.onRefresh,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _teLike = false;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _likes = widget.likesInicials;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Capçalera
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(radius: 20, backgroundColor: Colors.grey.shade300),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.autor, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.temps, style: const TextStyle(fontSize: 12)),
                  ],
                )
              ],
            ),
          ),

          // Imatge
          widget.urlImatge.startsWith("http")
              ? Image.network("${widget.urlImatge}?alt=media", fit: BoxFit.cover)
              : Image.file(File(widget.urlImatge), fit: BoxFit.cover),

          // Descripció
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(widget.descripcio),
          ),

          // Últim comentari
          if (widget.ultimComentari != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "${widget.ultimComentari!.nombreUsuario}: ${widget.ultimComentari!.texto}",
                style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ),

          // Accions
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _teLike ? Icons.favorite : Icons.favorite_border,
                  color: _teLike ? Colors.red : null,
                ),
                onPressed: () {
                  setState(() => _teLike = !_teLike);
                },
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () async {
                  final resultat = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PantallaComentarios(
                        publicacion: widget.publicacion,
                      ),
                    ),
                  );

                  if (resultat == true) widget.onRefresh?.call();
                },
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Text("${widget.likesInicials} m'agrades · ${widget.comentaris} comentaris"),
          ),
        ],
      ),
    );
  }
}
