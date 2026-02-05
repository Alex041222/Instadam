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

  @override
  Widget build(BuildContext context) {
    // Així es recrea cada vegada i el feed es refresca
    Widget pantallaActual;

    if (_index == 0) {
      pantallaActual = PantallaFeed(); // es recrea i refresca
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
        child: const Icon(Icons.add),
        onPressed: () async {
          final refrescar = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PantallaNuevaPublicacion(),
            ),
          );

          if (refrescar == true && mounted) {
            setState(() {});
          }
        },
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
