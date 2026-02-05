import 'base_datos.dart';
import 'package:sqflite/sqflite.dart';
import '../modelos/like.dart';

class LikeDAO {
  Future<bool> usuarioHaDadoLike(int idUsuario, int idPublicacion) async {
    final db = await BaseDatos.instancia.base;
    final res = await db.query(
      'likes',
      where: 'idUsuario = ? AND idPublicacion = ?',
      whereArgs: [idUsuario, idPublicacion],
    );
    return res.isNotEmpty;
  }

  Future<void> darLike(int idUsuario, int idPublicacion) async {
    final db = await BaseDatos.instancia.base;
    await db.insert('likes', {
      'idUsuario': idUsuario,
      'idPublicacion': idPublicacion,
    });
  }

  Future<void> quitarLike(int idUsuario, int idPublicacion) async {
    final db = await BaseDatos.instancia.base;
    await db.delete(
      'likes',
      where: 'idUsuario = ? AND idPublicacion = ?',
      whereArgs: [idUsuario, idPublicacion],
    );
  }

  Future<int> contarLikesDePublicacion(int idPublicacion) async {
    final db = await BaseDatos.instancia.base;
    final res = await db.rawQuery(
      'SELECT COUNT(*) as total FROM likes WHERE idPublicacion = ?',
      [idPublicacion],
    );
    return Sqflite.firstIntValue(res) ?? 0;
  }
}
