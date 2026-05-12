import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../servicios/servicio_autenticacion.dart';
import '../../servicios/servicio_preferencias.dart';
import 'pantalla_principal.dart';
import 'pantalla_registro.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final TextEditingController _controlUsuario = TextEditingController();
  final TextEditingController _controlContrasena = TextEditingController();

  final FocusNode _focusUsuario = FocusNode();
  final FocusNode _focusContrasena = FocusNode();

  bool _recordarUsuario = false;
  bool _cargando = false;

  String? _errorGlobal;

  @override
  void initState() {
    super.initState();
    _comprobarUsuarioGuardado();
  }

  Future<void> _comprobarUsuarioGuardado() async {
    final prefs = ServicioPreferencias.instancia;

    if (prefs.recordarUsuario &&
        ServicioAutenticacion.instancia.usuarioActual != null) {

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PantallaPrincipal()),
        );
      });
    }
  }

  Future<void> _iniciarSesion() async {
    setState(() {
      _cargando = true;
      _errorGlobal = null;
    });

    final email = _controlUsuario.text.trim();
    final contrasena = _controlContrasena.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        _cargando = false;
        _errorGlobal = "Email no válido";
      });
      return;
    }

    try {
      final usuario = await ServicioAutenticacion.instancia
          .iniciarSesion(email, contrasena);

      setState(() => _cargando = false);

      if (usuario == null) {
        setState(() {
          _errorGlobal = "Usuario no encontrado";
        });
        return;
      }

      await ServicioAutenticacion.instancia.guardarUsuario(usuario);
      ServicioPreferencias.instancia.recordarUsuario = _recordarUsuario;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PantallaPrincipal()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _cargando = false;
        if (e.code == 'user-not-found') _errorGlobal = "Usuario no encontrado";
        else if (e.code == 'wrong-password') _errorGlobal = "Contraseña incorrecta";
        else _errorGlobal = "Error: ${e.message}";
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
      appBar: AppBar(title: const Text("Iniciar sesión")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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

            const SizedBox(height: 40),

            if (_errorGlobal != null)
              Semantics(
                liveRegion: true,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    "Error: ${_errorGlobal!}",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

            TextField(
              controller: _controlUsuario,
              focusNode: _focusUsuario,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_focusContrasena),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: _controlContrasena,
              obscureText: true,
              focusNode: _focusContrasena,
              decoration: const InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: 15),

            Semantics(
              label: "Recordar usuario",
              toggled: _recordarUsuario,
              child: Row(
                children: [
                  Switch(
                    value: _recordarUsuario,
                    onChanged: (v) {
                      setState(() => _recordarUsuario = v);
                    },
                  ),
                  const Text("Recordar usuario"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _cargando
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: [

                // BOTÓ LOGIN AMB CONTORN GRUIXUT
                Semantics(
                  label: "Iniciar sesión",
                  button: true,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 2, // contorn gruixut
                      ),
                    ),
                    onPressed: _iniciarSesion,
                    child: const Text("Iniciar sesión"),
                  ),
                ),

                const SizedBox(height: 20),

                // TEXT PER ANAR A REGISTRE
                Semantics(
                  label: "¿No tienes cuenta? Regístrate aquí",
                  button: true,
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PantallaRegistro()),
                        );
                      },
                      child: const Text(
                        "¿No tienes cuenta? Regístrate",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
