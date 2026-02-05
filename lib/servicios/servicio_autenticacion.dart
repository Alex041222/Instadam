import 'package:shared_preferences/shared_preferences.dart';
import '../datos/bd/base_datos.dart';
import '../datos/modelos/usuario.dart';
import 'package:sqflite/sqflite.dart';

class ServicioAutenticacion {
  static final ServicioAutenticacion instancia = ServicioAutenticacion._();
  ServicioAutenticacion._();

  Usuario? usuarioActual;

  Future<Usuario?> iniciarSesion(String nombre, String contrasena) async {
    final db = await BaseDatos.instancia.base;

    final res = await db.query(
      'usuarios',
      where: 'nombre = ? AND contrasena = ?',
      whereArgs: [nombre, contrasena],
    );

    if (res.isEmpty) return null;

    final usuario = Usuario.fromMap(res.first);
    usuarioActual = usuario;

    return usuario;
  }

  Future<bool> registrar(String nombre, String contrasena) async {
    final db = await BaseDatos.instancia.base;

    // Comprovar si existeix
    final existe = await db.query(
      'usuarios',
      where: 'nombre = ?',
      whereArgs: [nombre],
    );

    if (existe.isNotEmpty) return false;

    await db.insert('usuarios', {
      'nombre': nombre,
      'contrasena': contrasena,
    });

    return true;
  }

  Future<void> guardarUsuario(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('idUsuario', usuario.id!);
    await prefs.setString('nombreUsuario', usuario.nombre);
    usuarioActual = usuario;
  }

  Future<void> cargarUsuarioGuardado() async {
    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getInt('idUsuario');
    final nombre = prefs.getString('nombreUsuario');

    if (id != null && nombre != null) {
      usuarioActual = Usuario(
        id: id,
        nombre: nombre,
        contrasena: '',
      );
    }
  }

  Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    usuarioActual = null;
  }
}
