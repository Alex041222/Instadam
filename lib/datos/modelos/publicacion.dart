import 'package:cloud_firestore/cloud_firestore.dart';

class Publicacion {
  String? id;
  String uidAutor;
  String nombreAutor;
  String descripcion;
  String rutaImagen;
  List<String> likes; // Llista d'UIDs
  int comentariosCount;
  DateTime fecha;

  Publicacion({
    this.id,
    required this.uidAutor,
    required this.nombreAutor,
    required this.descripcion,
    required this.rutaImagen,
    this.likes = const [],
    this.comentariosCount = 0,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'uidAutor': uidAutor,
      'nombreAutor': nombreAutor,
      'descripcion': descripcion,
      'rutaImagen': rutaImagen,
      'likes': likes,
      'comentariosCount': comentariosCount,
      'fecha': Timestamp.fromDate(fecha),
    };
  }

  factory Publicacion.fromMap(Map<String, dynamic> map, {String? documentId}) {
    DateTime fechaFinal;
    if (map['fecha'] is Timestamp) {
      fechaFinal = (map['fecha'] as Timestamp).toDate();
    } else if (map['fecha'] is String) {
      fechaFinal = DateTime.parse(map['fecha']);
    } else {
      fechaFinal = DateTime.now();
    }

    return Publicacion(
      id: documentId,
      uidAutor: map['uidAutor'] ?? '',
      nombreAutor: map['nombreAutor'] ?? 'Usuari',
      descripcion: map['descripcion'] ?? '',
      rutaImagen: map['rutaImagen'] ?? '',
      likes: List<String>.from(map['likes'] ?? []),
      comentariosCount: map['comentariosCount'] ?? 0,
      fecha: fechaFinal,
    );
  }
}
