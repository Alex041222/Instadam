class Comentario {
  int? id;
  int idPublicacion;
  String nombreUsuario;
  String texto;
  DateTime fecha;

  Comentario({
    this.id,
    required this.idPublicacion,
    required this.nombreUsuario,
    required this.texto,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idPublicacion': idPublicacion,
      'nombreUsuario': nombreUsuario,
      'texto': texto,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory Comentario.fromMap(Map<String, dynamic> map) {
    return Comentario(
      id: map['id'],
      idPublicacion: map['idPublicacion'],
      nombreUsuario: map['nombreUsuario'],
      texto: map['texto'],
      fecha: DateTime.parse(map['fecha']),
    );
  }
}
