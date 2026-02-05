import 'package:flutter/material.dart';
import '../../datos/bd/publicacion_dao.dart';
import '../../servicios/servicio_autenticacion.dart';
import '../widgets/tarjeta_publicacion.dart';

class PantallaFeedUsuario extends StatelessWidget {
  const PantallaFeedUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = ServicioAutenticacion.instancia.usuarioActual!;

    return Scaffold(
      appBar: AppBar(title: const Text("Mis publicaciones")),
      body: FutureBuilder(
        future: PublicacionDAO().obtenerPublicacionesDeUsuario(usuario.id!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final publicaciones = snapshot.data!;

          if (publicaciones.isEmpty) {
            return const Center(child: Text("No has publicado nada aún"));
          }

          return ListView.builder(
            itemCount: publicaciones.length,
            itemBuilder: (context, index) {
              return TarjetaPublicacion(
                publicacion: publicaciones[index],
                usuario: usuario,
              );
            },
          );
        },
      ),
    );
  }
}
