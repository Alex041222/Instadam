import 'package:flutter/material.dart';
import '../../datos/bd/publicacion_dao.dart';
import '../../datos/bd/usuario_dao.dart';
import '../../datos/modelos/publicacion.dart';
import '../../datos/modelos/usuario.dart';
import '../widgets/tarjeta_publicacion.dart';

class PantallaFeed extends StatefulWidget {
  const PantallaFeed({super.key});

  @override
  State<PantallaFeed> createState() => _PantallaFeedState();
}

class _PantallaFeedState extends State<PantallaFeed> {
  final PublicacionDAO _publicacionDAO = PublicacionDAO();
  final UsuarioDAO _usuarioDAO = UsuarioDAO();

  Future<List<Map<String, dynamic>>> _cargarFeed() async {
    final publicaciones = await _publicacionDAO.obtenerPublicaciones();
    List<Map<String, dynamic>> resultado = [];

    for (var pub in publicaciones) {
      final usuario = await _usuarioDAO.obtenerUsuarioPorId(pub.idUsuario);
      if (usuario != null) {
        resultado.add({"publicacion": pub, "usuario": usuario});
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

        if (datos.isEmpty) {
          return const Center(child: Text("No hay publicaciones todavía"));
        }

        return ListView.builder(
          itemCount: datos.length,
          itemBuilder: (context, index) {
            final pub = datos[index]["publicacion"] as Publicacion;
            final usu = datos[index]["usuario"] as Usuario;

            return TarjetaPublicacion(
              publicacion: pub,
              usuario: usu,
            );
          },
        );
      },
    );
  }
}
