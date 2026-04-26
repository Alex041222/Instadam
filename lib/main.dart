import 'package:flutter/material.dart';
import 'servicios/servicio_preferencias.dart';
import 'servicios/servicio_autenticacion.dart';
import 'tema_controller.dart';
import 'idioma_controller.dart';
import 'ui/pantallas/pantalla_router.dart';
import 'ui/pantallas/pantalla_principal.dart';
import 'ui/pantallas/pantalla_login.dart';
import 'ui/pantallas/pantallaSplash.dart';

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

            ThemeData temaClar = ThemeData(
              brightness: Brightness.light,
              primaryColor: const Color(0xFF1565C0),
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF1565C0),
                secondary: Color(0xFF1565C0),
                error: Color(0xFFD32F2F),
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Color(0xFF212121)),
                bodySmall: TextStyle(color: Color(0xFF424242)),
              ),
            );

            ThemeData temaFosc = ThemeData(
              brightness: Brightness.dark,
              primaryColor: const Color(0xFF1565C0),
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF1565C0),
                secondary: Color(0xFF1565C0),
                error: Color(0xFFD32F2F),
              ),
            );

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Instadam',

              themeMode: oscuro ? ThemeMode.dark : ThemeMode.light,
              theme: temaClar,
              darkTheme: temaFosc,
              home: const PantallaSplash(),

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
