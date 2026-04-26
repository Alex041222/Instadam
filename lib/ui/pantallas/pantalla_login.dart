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

    final nombre = _controlUsuario.text.trim();
    final contrasena = _controlContrasena.text.trim();

    final usuario = await ServicioAutenticacion.instancia
        .iniciarSesion(nombre, contrasena);

    setState(() => _cargando = false);

    if (usuario == null) {
      setState(() {
        _errorGlobal = "Usuario o contraseña incorrectos";
      });
      return;
    }

    await ServicioAutenticacion.instancia.guardarUsuario(usuario);
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
      setState(() {
        _errorGlobal = "Rellena usuario y contraseña";
      });
      return;
    }

    final ok = await ServicioAutenticacion.instancia
        .registrar(nombre, contrasena);

    setState(() {
      _errorGlobal = ok
          ? "Usuario registrado. Ahora inicia sesión."
          : "El usuario ya existe";
    });
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

            if (_errorGlobal != null)
              Semantics(
                liveRegion: true,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    _errorGlobal!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

            const Text("Usuario"),
            TextField(
              controller: _controlUsuario,
              focusNode: _focusUsuario,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_focusContrasena),
            ),

            const SizedBox(height: 15),

            const Text("Contraseña"),
            TextField(
              controller: _controlContrasena,
              obscureText: true,
              focusNode: _focusContrasena,
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

                const SizedBox(height: 10),

                // BOTÓ REGISTRE AMB CONTORN GRUIXUT
                Semantics(
                  label: "Registrarse",
                  button: true,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 2, // contorn gruixut
                      ),
                    ),
                    onPressed: _registrarse,
                    child: const Text("Registrarse"),
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
