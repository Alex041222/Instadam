import 'package:flutter/material.dart';
import 'pantalla_login.dart';

class PantallaSplash extends StatefulWidget {
  const PantallaSplash({super.key});

  @override
  State<PantallaSplash> createState() => _PantallaSplashState();
}

class _PantallaSplashState extends State<PantallaSplash> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PantallaLogin()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO AMB DESCRIPCIÓ
            Semantics(
              label: "Logo de InstaDAM",
              image: true,
              child: Image.asset(
                "assets/logo.png",
                width: 120,
                height: 120,
              ),
            ),

            const SizedBox(height: 20),

            // TEXT QUE S'ANUNCIA AUTOMÀTICAMENT
            Semantics(
              liveRegion: true,
              child: const Text(
                "Carregant aplicació...",
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 20),

            // INDICADOR DECORATIU (NO LLEGIBLE)
            ExcludeSemantics(
              child: const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
