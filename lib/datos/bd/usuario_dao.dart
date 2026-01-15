import 'package:sqflite/sqflite.dart';
import 'base_datos.dart';
import '../modelos/usuario.dart';

class UsuarioDAO {
  Future<int> insertarUsuario(Usuario usuario) async {
    final db = await BaseDatos.instancia.base;
    return await db.insert('usuarios', usuario.toMap());
  }

  Future<Usuario?> obtenerUsuario(String nombre, String contrasena) async {
    final db = await BaseDatos.instancia.base;

    final resultado = await db.query(
      'usuarios',
      where: 'nombre = ? AND contrasena = ?',
      whereArgs: [nombre, contrasena],
    );

    if (resultado.isNotEmpty) {
      return Usuario.fromMap(resultado.first);
    }
    return null;
  }
}
