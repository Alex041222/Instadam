import 'package:flutter/material.dart';
import '../../servicios/servicio_autenticacion.dart';
import '../../servicios/servicio_preferencias.dart';
import 'pantalla_principal.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final TextEditingController _controlUsuario = TextEditingController();
  final TextEditingController _controlContrasena = TextEditingController();
  bool _recordarUsuario = false;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _comprobarUsuarioGuardado();
  }

  Future<void> _comprobarUsuarioGuardado() async {
    final prefs = ServicioPreferencias.instancia;

    // Si l’usuari va marcar "recordar usuario" i hi ha usuari guardat → entrar directe
    if (prefs.recordarUsuario &&
        ServicioAutenticacion.instancia.usuarioActual != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PantallaPrincipal()),
      );
    }
  }

  Future<void> _iniciarSesion() async {
    setState(() => _cargando = true);

    final nombre = _controlUsuario.text.trim();
    final contrasena = _controlContrasena.text.trim();

    final usuario = await ServicioAutenticacion.instancia
        .iniciarSesion(nombre, contrasena);

    setState(() => _cargando = false);

    if (usuario == null) {
      _mostrarMensaje("Usuario o contraseña incorrectos");
      return;
    }

    // Guardar usuario en autenticación
    await ServicioAutenticacion.instancia.guardarUsuario(usuario);

    // Guardar preferencia de recordar usuario
    ServicioPreferencias.instancia.recordarUsuario = _recordarUsuario;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PantallaPrincipal()),
    );
  }

  Future<void> _registrarse() async {
    final nombre = _controlUsuario.text.trim();
    final contrasena = _controlContrasena.text.trim();

    if (nombre.isEmpty || contrasena.isEmpty) {
      _mostrarMensaje("Rellena usuario y contraseña");
      return;
    }

    final ok = await ServicioAutenticacion.instancia
        .registrar(nombre, contrasena);

    if (ok) {
      _mostrarMensaje("Usuario registrado. Ahora inicia sesión.");
    } else {
      _mostrarMensaje("El usuario ya existe");
    }
  }

  void _mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Iniciar sesión")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controlUsuario,
              decoration: const InputDecoration(
                labelText: "Usuario",
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _controlContrasena,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña",
              ),
            ),
            const SizedBox(height: 15),

            Row(
              children: [
                Checkbox(
                  value: _recordarUsuario,
                  onChanged: (v) {
                    setState(() => _recordarUsuario = v!);
                  },
                ),
                const Text("Recordar usuario"),
              ],
            ),

            const SizedBox(height: 20),

            _cargando
                ? const CircularProgressIndicator()
                : Column(
              children: [
                ElevatedButton(
                  onPressed: _iniciarSesion,
                  child: const Text("Iniciar sesión"),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: _registrarse,
                  child: const Text("Registrarse"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
