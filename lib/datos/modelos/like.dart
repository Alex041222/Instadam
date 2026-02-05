class Like {
  int? id;
  int idUsuario;
  int idPublicacion;

  Like({
    this.id,
    required this.idUsuario,
    required this.idPublicacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUsuario': idUsuario,
      'idPublicacion': idPublicacion,
    };
  }

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      id: map['id'],
      idUsuario: map['idUsuario'],
      idPublicacion: map['idPublicacion'],
    );
  }
}
