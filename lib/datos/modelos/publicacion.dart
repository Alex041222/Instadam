class Publicacion {
  int? id;
  int idUsuario;
  String descripcion;
  String rutaImagen;
  int likes;
  int comentarios;
  DateTime fecha;

  Publicacion({
    this.id,
    required this.idUsuario,
    required this.descripcion,
    required this.rutaImagen,
    required this.likes,
    required this.comentarios,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUsuario': idUsuario,
      'descripcion': descripcion,
      'rutaImagen': rutaImagen,
      'likes': likes,
      'comentarios': comentarios,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory Publicacion.fromMap(Map<String, dynamic> map) {
    return Publicacion(
      id: map['id'],
      idUsuario: map['idUsuario'],
      descripcion: map['descripcion'],
      rutaImagen: map['rutaImagen'],
      likes: map['likes'],
      comentarios: map['comentarios'],
      fecha: DateTime.parse(map['fecha']),
    );
  }
}
