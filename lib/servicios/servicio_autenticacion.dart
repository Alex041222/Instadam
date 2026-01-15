import 'package:shared_preferences/shared_preferences.dart';
import '../datos/bd/usuario_dao.dart';
import '../datos/modelos/usuario.dart';

class ServicioAutenticacion {
  static final ServicioAutenticacion instancia = ServicioAutenticacion._();
  final UsuarioDAO _usuarioDAO = UsuarioDAO();

  ServicioAutenticacion._();

  // -------------------------------------------------------------
  // REGISTRO
  // -------------------------------------------------------------
  Future<bool> registrar(String nombre, String contrasena) async {
    final usuario = Usuario(nombre: nombre, contrasena: contrasena);

    try {
      await _usuarioDAO.insertarUsuario(usuario);
      return true;
    } catch (e) {
      // Si el usuario ya existe o hay error
      return false;
    }
  }

  // -------------------------------------------------------------
  // LOGIN
  // -------------------------------------------------------------
  Future<Usuario?> iniciarSesion(String nombre, String contrasena) async {
    return await _usuarioDAO.obtenerUsuario(nombre, contrasena);
  }

  // -------------------------------------------------------------
  // RECORDAR USUARIO
  // -------------------------------------------------------------
  Future<void> guardarUsuarioRecordado(int idUsuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('usuario_recordado', true);
    await prefs.setInt('id_usuario_recordado', idUsuario);
  }

  Future<int?> obtenerUsuarioRecordado() async {
    final prefs = await SharedPreferences.getInstance();
    final recordado = prefs.getBool('usuario_recordado') ?? false;

    if (!recordado) return null;

    return prefs.getInt('id_usuario_recordado');
  }

  Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario_recordado');
    await prefs.remove('id_usuario_recordado');
  }
}
