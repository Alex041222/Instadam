import '../datos/bd/comentario_dao.dart';
import 'servicio_autenticacion.dart';

class ServicioComentarios {
  static final ServicioComentarios instancia = ServicioComentarios._();
  final ComentarioDAO _dao = ComentarioDAO();

  ServicioComentarios._();

  Future<void> comentar(int idPublicacion, String texto) async {
    final usuario = ServicioAutenticacion.instancia.usuarioActual;
    if (usuario == null) return;

    await _dao.insertarComentario(idPublicacion, usuario.nombre, texto);
  }

  Future<List<Map<String, dynamic>>> obtenerComentarios(int idPublicacion) {
    return _dao.obtenerComentarios(idPublicacion);
  }
}
