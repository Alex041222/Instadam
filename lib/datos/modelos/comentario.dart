import 'package:cloud_firestore/cloud_firestore.dart';

class Comentario {
  String? id;
  String idPublicacion;
  String uidAutor;
  String nombreUsuario;
  String texto;
  DateTime fecha;

  Comentario({
    this.id,
    required this.idPublicacion,
    required this.uidAutor,
    required this.nombreUsuario,
    required this.texto,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'idPublicacion': idPublicacion,
      'uidAutor': uidAutor,
      'nombreUsuario': nombreUsuario,
      'texto': texto,
      'fecha': Timestamp.fromDate(fecha),
    };
  }

  factory Comentario.fromMap(Map<String, dynamic> map, {String? documentId}) {
    DateTime fechaFinal;
    if (map['fecha'] is Timestamp) {
      fechaFinal = (map['fecha'] as Timestamp).toDate();
    } else if (map['fecha'] is String) {
      fechaFinal = DateTime.parse(map['fecha']);
    } else {
      fechaFinal = DateTime.now();
    }

    return Comentario(
      id: documentId,
      idPublicacion: map['idPublicacion'] ?? '',
      uidAutor: map['uidAutor'] ?? '',
      nombreUsuario: map['nombreUsuario'] ?? 'Usuari',
      texto: map['texto'] ?? '',
      fecha: fechaFinal,
    );
  }
}
