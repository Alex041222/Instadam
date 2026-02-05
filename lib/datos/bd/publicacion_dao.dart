import 'package:sqflite/sqflite.dart';
import 'base_datos.dart';
import '../modelos/publicacion.dart';

class PublicacionDAO {
  Future<int> insertarPublicacion(Publicacion publicacion) async {
    final db = await BaseDatos.instancia.base;
    return await db.insert('publicaciones', publicacion.toMap());
  }

  Future<List<Publicacion>> obtenerPublicaciones() async {
    final db = await BaseDatos.instancia.base;

    final resultado = await db.query(
      'publicaciones',
      orderBy: 'fecha DESC',
    );

    return resultado.map((fila) => Publicacion.fromMap(fila)).toList();
  }

  Future<List<Publicacion>> obtenerPublicacionesDeUsuario(int idUsuario) async {
    final db = await BaseDatos.instancia.base;

    final resultado = await db.query(
      'publicaciones',
      where: 'idUsuario = ?',
      whereArgs: [idUsuario],
      orderBy: 'fecha DESC',
    );

    return resultado.map((fila) => Publicacion.fromMap(fila)).toList();
  }
  Future<void> actualizarLikes(int idPublicacion, int likes) async {
    final db = await BaseDatos.instancia.base;
    await db.update(
      'publicaciones',
      {'likes': likes},
      where: 'id = ?',
      whereArgs: [idPublicacion],
    );
  }

  Future<void> actualizarComentarios(int idPublicacion, int comentarios) async {
    final db = await BaseDatos.instancia.base;
    await db.update(
      'publicaciones',
      {'comentarios': comentarios},
      where: 'id = ?',
      whereArgs: [idPublicacion],
    );
  }

}
