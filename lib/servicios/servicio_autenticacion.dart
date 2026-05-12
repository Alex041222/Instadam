import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../datos/modelos/usuario.dart';
import 'servicio_firestore.dart';

class ServicioAutenticacion {
  static final ServicioAutenticacion instancia = ServicioAutenticacion._();
  ServicioAutenticacion._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Usuario? usuarioActual;

  // Stream per escoltar canvis d'estat (opcional)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<Usuario?> iniciarSesion(String email, String contrasena) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: contrasena,
      );

      if (credential.user != null) {
        usuarioActual = await ServicioFirestore.instancia
            .obtenerUsuario(credential.user!.uid);
        return usuarioActual;
      }
    } on FirebaseAuthException catch (e) {
      print("Error login: ${e.code}");
      rethrow; // Per capturar el missatge a la UI
    }
    return null;
  }

  Future<bool> registrar(String nombre, String email, String contrasena) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: contrasena,
      );

      if (credential.user != null) {
        final nouUsuari = Usuario(
          id: credential.user!.uid,
          nombre: nombre,
          email: email,
          fechaCreacion: DateTime.now(),
        );

        await ServicioFirestore.instancia.guardarUsuario(nouUsuari);
        usuarioActual = nouUsuari;
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print("Error registre: ${e.code}");
      rethrow;
    }
    return false;
  }

  Future<void> guardarUsuario(Usuario usuario) async {
    // No cal guardar tota la info a prefs, Firebase ja ho gestiona
    // Però guardem el nombre per si de cas o per "recordar usuario"
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombreUsuario', usuario.nombre);
    usuarioActual = usuario;
  }

  Future<void> cargarUsuarioGuardado() async {
    final user = _auth.currentUser;
    if (user != null) {
      usuarioActual = await ServicioFirestore.instancia.obtenerUsuario(user.uid);
    }
  }

  Future<void> cerrarSesion() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    // No esborrem tot el tema/idioma, només info d'usuari
    await prefs.remove('nombreUsuario');
    usuarioActual = null;
  }
}
