
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BaseDatos {
  static final BaseDatos instancia = BaseDatos._();
  static Database? _bd;

  BaseDatos._();

  Future<Database> get base async {
    if (_bd != null) return _bd!;
    _bd = await _inicializarBD();
    return _bd!;
  }

  Future<Database> _inicializarBD() async {
    final rutaBD = await getDatabasesPath();
    final ruta = join(rutaBD, 'instadam.db');

    return await openDatabase(
      ruta,
      version: 1,
      onCreate: _crearTablas,
    );
  }

  Future<void> _crearTablas(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT UNIQUE,
        contrasena TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE publicaciones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER,
        ruta_imagen TEXT,
        descripcion TEXT,
        fecha TEXT,
        likes INTEGER,
        comentarios INTEGER,
        FOREIGN KEY(usuario_id) REFERENCES usuarios(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE comentarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        publicacion_id INTEGER,
        usuario TEXT,
        texto TEXT,
        fecha TEXT,
        FOREIGN KEY(publicacion_id) REFERENCES publicaciones(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE likes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        publicacion_id INTEGER,
        usuario_id INTEGER,
        UNIQUE(publicacion_id, usuario_id)
      );
    ''');
  }
}
