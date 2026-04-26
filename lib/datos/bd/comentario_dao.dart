import 'package:sqflite/sqflite.dart';
import 'base_datos.dart';
import '../modelos/comentario.dart';
import 'publicacion_dao.dart';

class ComentarioDAO {
  Future<int> insertarComentario(Comentario c) async {
    final db = await BaseDatos.instancia.base;

    final id = await db.insert('comentarios', c.toMap());

    // Incrementa el contador de comentarios en la publicación
    await PublicacionDAO().incrementarComentarios(c.idPublicacion);

    return id;
  }

  Future<List<Comentario>> obtenerComentariosDePublicacion(int idPublicacion) async {
    final db = await BaseDatos.instancia.base;

    final res = await db.query(
      'comentarios',
      where: 'idPublicacion = ?',
      whereArgs: [idPublicacion],
      orderBy: 'fecha ASC',
    );

    return res.map((e) => Comentario.fromMap(e)).toList();
  }

  Future<Comentario?> obtenerUltimoComentario(int idPublicacion) async {
    final db = await BaseDatos.instancia.base;

    final res = await db.query(
      'comentarios',
      where: 'idPublicacion = ?',
      whereArgs: [idPublicacion],
      orderBy: 'fecha DESC',
      limit: 1,
    );

    if (res.isEmpty) return null;
    return Comentario.fromMap(res.first);
  }
  Future<int> contarComentariosDePublicacion(int idPublicacion) async {
    final db = await BaseDatos.instancia.base;

    final res = await db.rawQuery(
      'SELECT COUNT(*) as total FROM comentarios WHERE idPublicacion = ?',
      [idPublicacion],
    );

    return Sqflite.firstIntValue(res) ?? 0;
  }


}
