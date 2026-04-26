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
      builder: (context, idioma, _) {
        final es = idioma == "es";

        return Scaffold(
          appBar: AppBar(
            title: Text(es ? "Configuración" : "Configuració"),
          ),
          body: ListView(
            children: [
              // --- Switch Tema ---
              Semantics(
                label: es ? "Cambiar a tema oscuro" : "Canviar a tema fosc",
                toggled: prefs.temaOscuro,
                hint: es
                    ? "Si lo activas, toda la aplicación usará colores oscuros"
                    : "Si l'actives, tota l'aplicació usarà colors foscos",
                child: SwitchListTile(
                  title: Text(es ? "Tema oscuro" : "Tema fosc"),
                  value: prefs.temaOscuro,
                  onChanged: (v) {
                    prefs.temaOscuro = v;
                    TemaController.instancia.temaOscuro.value = v;
                    setState(() {});

                    final msg = es
                        ? (v ? "Tema oscuro activado" : "Tema oscuro desactivado")
                        : (v ? "Tema fosc activat" : "Tema fosc desactivat");

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(msg)),
                    );
                  },
                ),
              ),

              // --- Switch Notificaciones ---
              Semantics(
                label: es ? "Notificaciones" : "Notificacions",
                toggled: prefs.notificaciones,
                hint: es
                    ? "Activa o desactiva las alertas sonoras y visuales"
                    : "Activa o desactiva les alertes sonores i visuals",
                child: SwitchListTile(
                  title: Text(es ? "Notificaciones" : "Notificacions"),
                  value: prefs.notificaciones,
                  onChanged: (v) {
                    prefs.notificaciones = v;
                    setState(() {});

                    final msg = es
                        ? (v ? "Notificaciones activadas" : "Notificaciones desactivadas")
                        : (v ? "Notificacions activades" : "Notificacions desactivades");

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(msg)),
                    );
                  },
                ),
              ),

              // --- Selector de Idioma ---
              ListTile(
                title: Text(
                  es ? "Selector de idioma" : "Selector d'idioma",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  es ? "Idioma actual: Español" : "Idioma actual: Català",
                ),
                trailing: Semantics(
                  button: true,
                  label: es ? "Cambiar idioma" : "Canviar idioma",
                  hint: es
                      ? "Presiona para elegir entre Español y Català"
                      : "Prem per triar entre Español i Català",
                  child: DropdownButton<String>(
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

                        final msg = v == "es"
                            ? "Idioma cambiado a Español"
                            : "Idioma canviat a Català";

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(msg)),
                        );
                      }
                    },
                  ),
                ),
              ),

              const Divider(),

              // --- Botón de Cerrar Sesión ---
              Semantics(
                button: true,
                label: es ? "Botón de cerrar sesión" : "Botó de tancar sessió",
                hint: es
                    ? "Abre un diálogo para confirmar la salida"
                    : "Obre un diàleg per confirmar la sortida",
                child: ListTile(
                  title: Text(
                    es ? "Cerrar sesión" : "Tancar sessió",
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: Semantics(
                          header: true,
                          child: Text(es ? "Cerrar sesión" : "Tancar sessió"),
                        ),
                        content: Semantics(
                          label: es
                              ? "¿Estás seguro de que quieres cerrar la sesión?"
                              : "Estàs segur que vols tancar la sessió?",
                          child: Text(es
                              ? "¿Estás seguro de que quieres cerrar la sesión?"
                              : "Estàs segur que vols tancar la sessió?"),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: Semantics(
                              label: es ? "Botón Cancelar" : "Botó Cancel·lar",
                              child: Text(es ? "Cancelar" : "Cancel·lar"),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              await ServicioPreferencias.instancia.cerrarSesion();
                              await ServicioAutenticacion.instancia.cerrarSesion();

                              if (mounted) {
                                navigator.pushNamedAndRemoveUntil(
                                    '/', (_) => false);
                              }
                            },
                            child: Semantics(
                              label: es ? "Confirmar cerrar sesión" : "Confirmar tancar sessió",
                              child: Text(es ? "Cerrar sesión" : "Tancar sessió"),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
