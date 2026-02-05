import 'package:flutter/material.dart';
import 'servicios/servicio_preferencias.dart';
import 'servicios/servicio_autenticacion.dart';
import 'tema_controller.dart';
import 'idioma_controller.dart';
import 'ui/pantallas/pantalla_router.dart';
import 'package:instadam/ui/pantallas/pantalla_principal.dart';
import 'package:instadam/ui/pantallas/pantalla_login.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ServicioPreferencias.instancia.init();
  await ServicioAutenticacion.instancia.cargarUsuarioGuardado();

  TemaController.instancia.temaOscuro.value =
      ServicioPreferencias.instancia.temaOscuro;

  IdiomaController.instancia.idioma.value =
      ServicioPreferencias.instancia.idioma;

  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: TemaController.instancia.temaOscuro,
      builder: (_, oscuro, __) {
        return ValueListenableBuilder<String>(
          valueListenable: IdiomaController.instancia.idioma,
          builder: (_, idioma, __) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Instadam',

              themeMode: oscuro ? ThemeMode.dark : ThemeMode.light,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),

              home: const PantallaRouter(),

              routes: {
                '/login': (_) => const PantallaLogin(),
                '/principal': (_) => const PantallaPrincipal(),
              },
            );
          },
        );
      },
    );
  }
}
