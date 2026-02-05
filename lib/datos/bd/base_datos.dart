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
      version: 2,
      onCreate: _crearTablas,
      onUpgrade: _actualizarTablas,
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
        idUsuario INTEGER,
        rutaImagen TEXT,
        descripcion TEXT,
        fecha TEXT,
        likes INTEGER DEFAULT 0,
        comentarios INTEGER DEFAULT 0,
        FOREIGN KEY(idUsuario) REFERENCES usuarios(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE comentarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idPublicacion INTEGER,
        nombreUsuario TEXT,
        texto TEXT,
        fecha TEXT,
        FOREIGN KEY(idPublicacion) REFERENCES publicaciones(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE likes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idUsuario INTEGER,
        idPublicacion INTEGER,
        UNIQUE(idUsuario, idPublicacion)
      );
    ''');
  }

  Future<void> _actualizarTablas(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS likes');
      await db.execute('DROP TABLE IF EXISTS comentarios');

      await db.execute('''
        CREATE TABLE comentarios (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          idPublicacion INTEGER,
          nombreUsuario TEXT,
          texto TEXT,
          fecha TEXT
        );
      ''');

      await db.execute('''
        CREATE TABLE likes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          idUsuario INTEGER,
          idPublicacion INTEGER,
          UNIQUE(idUsuario, idPublicacion)
        );
      ''');
    }
  }
}
