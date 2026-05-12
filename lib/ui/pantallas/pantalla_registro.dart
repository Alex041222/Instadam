import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../servicios/servicio_autenticacion.dart';
import 'pantalla_principal.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _controlNombre = TextEditingController();
  final _controlEmail = TextEditingController();
  final _controlContrasena = TextEditingController();

  String? _errorGlobal;
  bool _cargando = false;

  Future<void> _registrar() async {
    final nombre = _controlNombre.text.trim();
    final email = _controlEmail.text.trim();
    final contrasena = _controlContrasena.text.trim();

    if (nombre.isEmpty) {
      setState(() => _errorGlobal = "El nom és obligatori");
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorGlobal = "Email no vàlid");
      return;
    }
    if (contrasena.length < 6) {
      setState(() => _errorGlobal = "Contrasenya massa curta (mín 6 caràcters)");
      return;
    }

    setState(() {
      _cargando = true;
      _errorGlobal = null;
    });

    try {
      final ok = await ServicioAutenticacion.instancia.registrar(nombre, email, contrasena);
      if (ok && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const PantallaPrincipal()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _cargando = false;
        if (e.code == 'email-already-in-use') {
          _errorGlobal = "Aquest email ja està en ús";
        } else if (e.code == 'invalid-email') {
          _errorGlobal = "Format d'email incorrecte";
        } else {
          _errorGlobal = "Error: ${e.message}";
        }
      });
    } catch (e) {
      setState(() {
        _cargando = false;
        _errorGlobal = "S'ha produït un error inesperat";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar-se")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Semantics(
                label: "Logo de InstaDAM",
                image: true,
                child: Image.asset(
                  "assets/logo.png",
                  width: 250,
                  height: 250,
                  errorBuilder: (_, __, ___) => const Icon(Icons.photo, size: 250),
                ),
              ),
            ),
            const SizedBox(height: 30),

            if (_errorGlobal != null)
              Semantics(
                liveRegion: true,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    "Error: $_errorGlobal",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

            // CAMP NOM
            Semantics(
              label: "Camp per introduir el teu nom. Obligatori.",
              child: TextField(
                controller: _controlNombre,
                decoration: const InputDecoration(
                  labelText: "Nom complet",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // CAMP EMAIL
            Semantics(
              label: "Camp per introduir l'email.",
              child: TextField(
                controller: _controlEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // CAMP CONTRASENYA
            Semantics(
              label: "Camp per introduir la contrasenya. Mínim 6 caràcters.",
              child: TextField(
                controller: _controlContrasena,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Contrasenya",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // BOTÓ REGISTRAR
            Semantics(
              label: _cargando ? "Registrant..." : "Botó per crear el teu compte",
              button: true,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  onPressed: _cargando ? null : _registrar,
                  child: _cargando
                      ? const CircularProgressIndicator()
                      : const Text("Crear compte", style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
