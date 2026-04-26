import 'package:flutter/material.dart';
import '../../datos/bd/publicacion_dao.dart';
import '../../datos/bd/usuario_dao.dart';
import '../../datos/bd/comentario_dao.dart';
import '../../datos/modelos/publicacion.dart';
import '../../datos/modelos/usuario.dart';
import '../../datos/modelos/comentario.dart';
import '../widgets/tarjeta_publicacion.dart';   // ← IMPORTANT

class PantallaFeed extends StatefulWidget {
  const PantallaFeed({super.key});

  @override
  State<PantallaFeed> createState() => _PantallaFeedState();
}

class _PantallaFeedState extends State<PantallaFeed> {
  final PublicacionDAO _publicacionDAO = PublicacionDAO();
  final UsuarioDAO _usuarioDAO = UsuarioDAO();
  final ComentarioDAO _comentarioDAO = ComentarioDAO();

  Future<List<Map<String, dynamic>>> _cargarFeed() async {
    final publicaciones = await _publicacionDAO.obtenerPublicaciones();
    List<Map<String, dynamic>> resultado = [];

    for (var pub in publicaciones) {
      final usuario = await _usuarioDAO.obtenerUsuarioPorId(pub.idUsuario);
      final Comentario? ultimoComentario =
      await _comentarioDAO.obtenerUltimoComentario(pub.id!);

      if (usuario != null) {
        resultado.add({
          "publicacion": pub,
          "usuario": usuario,
          "ultimoComentario": ultimoComentario,
        });
      }
    }

    return resultado;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cargarFeed(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final datos = snapshot.data as List<Map<String, dynamic>>;

        return RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: ListView.builder(
            itemCount: datos.length,
            itemBuilder: (context, index) {
              final Publicacion pub = datos[index]["publicacion"];
              final Usuario usu = datos[index]["usuario"];
              final Comentario? ultimoComentario = datos[index]["ultimoComentario"];

              return TarjetaPublicacion(
                publicacion: pub,
                usuario: usu,
                onRefresh: () => setState(() {}),   // ← AIXÒ FA QUE TOT FUNCIONI
              );
            },
          ),
        );
      },
    );
  }
}
