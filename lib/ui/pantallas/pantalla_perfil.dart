import 'package:flutter/material.dart';
import '../../servicios/servicio_autenticacion.dart';
import '../../datos/bd/publicacion_dao.dart';
import '../../datos/modelos/publicacion.dart';
import '../widgets/tarjeta_publicacion.dart';
import 'pantalla_configuracion.dart';
import '../../idioma_controller.dart';

class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil({super.key});

  @override
  State<PantallaPerfil> createState() => _PantallaPerfilState();
}

class _PantallaPerfilState extends State<PantallaPerfil> {
  List<Publicacion> _misPublicaciones = [];

  @override
  void initState() {
    super.initState();
    _cargarMisPublicaciones();
  }

  Future<void> _cargarMisPublicaciones() async {
    final usuario = ServicioAutenticacion.instancia.usuarioActual!;
    final lista = await PublicacionDAO()
        .obtenerPublicacionesDeUsuario(usuario.id!);

    if (!mounted) return;
    setState(() {
      _misPublicaciones = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuario = ServicioAutenticacion.instancia.usuarioActual!;

    return ValueListenableBuilder<String>(
      valueListenable: IdiomaController.instancia.idioma,
      builder: (_, idioma, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              idioma == "es" ? "Mi Perfil" : "El meu perfil",
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PantallaConfiguracion(),
                    ),
                  );
                },
              ),
            ],
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // FOTO DE PERFIL
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, size: 60),
                ),

                const SizedBox(height: 20),

                // NOM D'USUARI
                Text(
                  usuario.nombre,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // TÍTOL
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    idioma == "es"
                        ? "Mis publicaciones"
                        : "Les meves publicacions",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // LLISTA DE PUBLICACIONS
                if (_misPublicaciones.isEmpty)
                  Text(
                    idioma == "es"
                        ? "Todavía no has publicado nada."
                        : "Encara no has publicat res.",
                    style: const TextStyle(color: Colors.grey),
                  )
                else
                  Column(
                    children: _misPublicaciones.map((pub) {
                      return TarjetaPublicacion(
                        publicacion: pub,
                        usuario: usuario,
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
