import '../datos/bd/comentario_dao.dart';
import '../datos/modelos/comentario.dart';
import 'servicio_autenticacion.dart';

class ServicioComentarios {
  static final ServicioComentarios instancia = ServicioComentarios._();
  final ComentarioDAO _dao = ComentarioDAO();

  ServicioComentarios._();

  Future<void> comentar(int idPublicacion, String texto) async {
    final usuario = ServicioAutenticacion.instancia.usuarioActual;
    if (usuario == null) return;

    final comentario = Comentario(
      idPublicacion: idPublicacion,
      nombreUsuario: usuario.nombre,
      texto: texto,
      fecha: DateTime.now(),
    );

    await _dao.insertarComentario(comentario);
  }

  Future<List<Comentario>> obtenerComentarios(int idPublicacion) {
    return _dao.obtenerComentariosDePublicacion(idPublicacion);
  }
}
