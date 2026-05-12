class Usuario {
  final String? id; // UID de Firebase
  final String nombre;
  final String email;
  final String biografia;
  final String fotoPerfil;
  final DateTime? fechaCreacion;

  Usuario({
    this.id,
    required this.nombre,
    required this.email,
    this.biografia = '',
    this.fotoPerfil = '',
    this.fechaCreacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'biografia': biografia,
      'fotoPerfil': fotoPerfil,
      'fechaCreacion': fechaCreacion?.toIso8601String(),
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return Usuario(
      id: documentId ?? map['id'],
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      biografia: map['biografia'] ?? '',
      fotoPerfil: map['fotoPerfil'] ?? '',
      fechaCreacion: map['fechaCreacion'] != null
          ? DateTime.parse(map['fechaCreacion'])
          : null,
    );
  }
}
