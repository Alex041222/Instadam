import 'package:flutter/material.dart';
import '../../servicios/servicio_preferencias.dart';
import '../../servicios/servicio_autenticacion.dart';
import '../../tema_controller.dart';
import '../../idioma_controller.dart';

class PantallaConfiguracion extends StatefulWidget {
  const PantallaConfiguracion({super.key});

  @override
  State<PantallaConfiguracion> createState() => _PantallaConfiguracionState();
}

class _PantallaConfiguracionState extends State<PantallaConfiguracion> {
  @override
  Widget build(BuildContext context) {
    final prefs = ServicioPreferencias.instancia;

    return ValueListenableBuilder<String>(
      valueListenable: IdiomaController.instancia.idioma,
      builder: (_, idioma, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(idioma == "es" ? "Configuración" : "Configuració"),
          ),
          body: ListView(
            children: [
              SwitchListTile(
                title: Text(idioma == "es" ? "Tema oscuro" : "Tema fosc"),
                value: prefs.temaOscuro,
                onChanged: (v) {
                  prefs.temaOscuro = v;
                  TemaController.instancia.temaOscuro.value = v;
                  setState(() {});
                },
              ),

              SwitchListTile(
                title: Text(idioma == "es" ? "Notificaciones" : "Notificacions"),
                value: prefs.notificaciones,
                onChanged: (v) {
                  prefs.notificaciones = v;
                  setState(() {});
                },
              ),

              ListTile(
                title: Text(idioma == "es" ? "Idioma" : "Idioma"),
                subtitle: Text(
                  prefs.idioma == "es" ? "Español" : "Català",
                ),
                trailing: DropdownButton<String>(
                  value: prefs.idioma,
                  items: const [
                    DropdownMenuItem(value: "es", child: Text("Español")),
                    DropdownMenuItem(value: "ca", child: Text("Català")),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      prefs.idioma = v;
                      IdiomaController.instancia.idioma.value = v;
                      setState(() {});
                    }
                  },
                ),
              ),

              const Divider(),

              ListTile(
                title: Text(
                  idioma == "es" ? "Cerrar sesión" : "Tancar sessió",
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  await ServicioPreferencias.instancia.cerrarSesion();
                  await ServicioAutenticacion.instancia.cerrarSesion();

                  if (mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (_) => false);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
