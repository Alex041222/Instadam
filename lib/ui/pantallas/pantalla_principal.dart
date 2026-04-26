import 'package:flutter/material.dart';
import 'pantalla_feed.dart';
import 'pantalla_perfil.dart';
import 'pantalla_nueva_publicacion.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _index = 0;

  // Evita doble clic i errors de Navigator en MIUI
  bool _navegando = false;

  @override
  Widget build(BuildContext context) {
    Widget pantallaActual;

    if (_index == 0) {
      pantallaActual = PantallaFeed();
    } else {
      pantallaActual = const PantallaPerfil();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _index == 0 ? "Instadam" : "Mi Perfil",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: pantallaActual,

      floatingActionButton: _index == 0
          ? FloatingActionButton(
        onPressed: _navegando
            ? null
            : () async {
          setState(() => _navegando = true);

          final refrescar = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PantallaNuevaPublicacion(),
            ),
          );

          setState(() => _navegando = false);

          if (refrescar == true && mounted) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      )
          : null,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) {
          setState(() {
            _index = i;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Feed"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}
