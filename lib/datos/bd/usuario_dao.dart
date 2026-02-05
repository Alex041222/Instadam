import 'package:sqflite/sqflite.dart';
import 'base_datos.dart';
import '../modelos/usuario.dart';

class UsuarioDAO {
  Usuario? usuarioActual;

  // -------------------------------------------------------------
  // INSERTAR USUARIO (REGISTRO)
  // -------------------------------------------------------------
  Future<int> insertarUsuario(Usuario usuario) async {
    final db = await BaseDatos.instancia.base;
    return await db.insert('usuarios', usuario.toMap());
  }

  // -------------------------------------------------------------
  // OBTENER USUARIO (LOGIN)
  // -------------------------------------------------------------
  Future<Usuario?> obtenerUsuario(String nombre, String contrasena) async {
    final db = await BaseDatos.instancia.base;

    final resultado = await db.query(
      'usuarios',
      where: 'nombre = ? AND contrasena = ?',
      whereArgs: [nombre, contrasena],
    );

    if (resultado.isEmpty) return null;

    usuarioActual = Usuario.fromMap(resultado.first);
    return usuarioActual;
  }

  // -------------------------------------------------------------
  // OBTENER USUARIO ACTUAL
  // -------------------------------------------------------------
  Usuario? obtenerUsuarioActual() {
    return usuarioActual;
  }
  Future<Usuario?> obtenerUsuarioPorId(int id) async {
    final db = await BaseDatos.instancia.base;

    final resultado = await db.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (resultado.isEmpty) return null;

    return Usuario.fromMap(resultado.first);
  }

}

