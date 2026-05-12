import 'package:flutter/material.dart';
import '../../datos/modelos/publicacion.dart';
import '../../servicios/servicio_firestore.dart';
import '../widgets/tarjeta_publicacion.dart';

class PantallaFeed extends StatefulWidget {
  const PantallaFeed({super.key});

  @override
  State<PantallaFeed> createState() => _PantallaFeedState();
}

class _PantallaFeedState extends State<PantallaFeed> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Publicacion>>(
      stream: ServicioFirestore.instancia.obtenerPublicaciones(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final publicaciones = snapshot.data ?? [];

        if (publicaciones.isEmpty) {
          return const Center(child: Text("No hi ha publicacions encara."));
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView.builder(
            itemCount: publicaciones.length,
            itemBuilder: (context, index) {
              final pub = publicaciones[index];
              return TarjetaPublicacion(
                publicacion: pub,
                onRefresh: () => setState(() {}),
              );
            },
          ),
        );
      },
    );
  }
}
