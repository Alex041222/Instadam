import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final String autor;
  final String temps;
  final String descripcio;
  final String altImatge;
  final String urlImatge;
  final int likesInicials;
  final int comentaris;

  const PostCard({
    super.key,
    required this.autor,
    required this.temps,
    required this.descripcio,
    required this.altImatge,
    required this.urlImatge,
    required this.likesInicials,
    required this.comentaris,
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

  void _toggleLike() {
    setState(() {
      _teLike = !_teLike;
      _likes += _teLike ? 1 : -1;
    });

    // Anunci del canvi (liveRegion)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Semantics(
          liveRegion: true,
          child: Text(_teLike
              ? "Has donat m'agrada"
              : "Has tret el m'agrada"),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        label:
        "Publicació de ${widget.autor}, ${widget.temps}. "
            "${widget.descripcio}. "
            "$_likes m'agrades, ${widget.comentaris} comentaris.",
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Capçalera
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    // Avatar decoratiu → no cal llegir-lo
                    ExcludeSemantics(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.autor,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        Text(widget.temps,
                            style: const TextStyle(fontSize: 12)),
                      ],
                    )
                  ],
                ),
              ),

              // Imatge amb alt text
              Semantics(
                label: widget.altImatge,
                child: Image.network(widget.urlImatge),
              ),

              // Descripció
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(widget.descripcio),
              ),

              // Accions
              Row(
                children: [
                  // Botó Like amb estat
                  Semantics(
                    button: true,
                    toggled: _teLike,
                    label: _teLike
                        ? "Treure m'agrada"
                        : "Donar m'agrada",
                    child: IconButton(
                      icon: Icon(
                        _teLike
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _teLike ? Colors.red : null,
                      ),
                      onPressed: _toggleLike,
                    ),
                  ),

                  // Botó comentaris
                  Semantics(
                    button: true,
                    label:
                    "Veure comentaris. ${widget.comentaris} comentaris",
                    child: IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () {
                        // Aquí obriries la pantalla de comentaris
                      },
                    ),
                  ),
                ],
              ),

              // Likes i comentaris en text
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text("$_likes m'agrades · ${widget.comentaris} comentaris"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
