import 'package:flutter/material.dart';
import '../../servicios/servicio_preferencias.dart';
import '../../servicios/servicio_autenticacion.dart';
import 'pantalla_login.dart';
import 'pantalla_principal.dart';

class PantallaRouter extends StatelessWidget {
  const PantallaRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = ServicioPreferencias.instancia;
    final usuario = ServicioAutenticacion.instancia.usuarioActual;

    // Si NO vol recordar → sempre login
    if (!prefs.recordarUsuario) {
      return const PantallaLogin();
    }

    // Si vol recordar i hi ha usuari → entra directe
    return usuario == null
        ? const PantallaLogin()
        : const PantallaPrincipal();
  }
}
