import 'package:flutter/material.dart';
import '../../servicios/servicio_autenticacion.dart';
import '../../servicios/servicio_firestore.dart';
import '../../datos/modelos/publicacion.dart';
import '../../datos/modelos/usuario.dart';
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
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final usuario = ServicioAutenticacion.instancia.usuarioActual!;
    final lista = await ServicioFirestore.instancia
        .obtenerPublicacionesUsuario(usuario.id!);

    if (!mounted) return;
    setState(() {
      _misPublicaciones = lista;
      _cargando = false;
    });
  }

  Future<void> _editarPerfil() async {
    final usuario = ServicioAutenticacion.instancia.usuarioActual!;
    final nameController = TextEditingController(text: usuario.nombre);
    final bioController = TextEditingController(text: usuario.biografia);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Perfil"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: "Biografía"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedUser = Usuario(
                id: usuario.id,
                nombre: nameController.text.trim(),
                email: usuario.email,
                biografia: bioController.text.trim(),
                fotoPerfil: usuario.fotoPerfil,
                fechaCreacion: usuario.fechaCreacion,
              );
              await ServicioFirestore.instancia.guardarUsuario(updatedUser);
              ServicioAutenticacion.instancia.usuarioActual = updatedUser;
              Navigator.pop(context, true);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() {});
    }
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

          body: _cargando 
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // FOTO DE PERFIL
                Semantics(
                  label: "Foto de perfil",
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, size: 60),
                  ),
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

                if (usuario.biografia.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    usuario.biografia,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],

                const SizedBox(height: 15),

                ElevatedButton.icon(
                  onPressed: _editarPerfil,
                  icon: const Icon(Icons.edit),
                  label: const Text("Editar Perfil"),
                ),

                const SizedBox(height: 30),

                // TÍTOL
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    idioma == "es"
                        ? "Mis publicaciones (${_misPublicaciones.length})"
                        : "Les meves publicacions (${_misPublicaciones.length})",
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
