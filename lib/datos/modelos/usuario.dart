class Usuario {
  final int? id;
  final String nombre;
  final String contrasena;

  Usuario({
    this.id,
    required this.nombre,
    required this.contrasena,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'contrasena': contrasena,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nombre: map['nombre'],
      contrasena: map['contrasena'],
    );
  }
}
