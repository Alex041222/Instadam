import 'package:cloud_firestore/cloud_firestore.dart';
import '../datos/modelos/usuario.dart';
import '../datos/modelos/publicacion.dart';
import '../datos/modelos/comentario.dart';

class ServicioFirestore {
  static final ServicioFirestore instancia = ServicioFirestore._();
  ServicioFirestore._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- USUARIS ---

  Future<void> guardarUsuario(Usuario usuario) async {
    await _db.collection('usuarios').doc(usuario.id).set(usuario.toMap());
  }

  Future<Usuario?> obtenerUsuario(String uid) async {
    final doc = await _db.collection('usuarios').doc(uid).get();
    if (!doc.exists) return null;
    return Usuario.fromMap(doc.data()!, documentId: doc.id);
  }

  // --- PUBLICACIONS ---

  Future<void> crearPublicacion(Publicacion pub) async {
    await _db.collection('publicaciones').add(pub.toMap());
  }

  Stream<List<Publicacion>> obtenerPublicaciones() {
    return _db
        .collection('publicaciones')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Publicacion.fromMap(doc.data(), documentId: doc.id))
          .toList();
    });
  }

  Future<List<Publicacion>> obtenerPublicacionesUsuario(String uid) async {
    final snapshot = await _db
        .collection('publicaciones')
        .where('uidAutor', isEqualTo: uid)
        .get();

    return snapshot.docs
        .map((doc) => Publicacion.fromMap(doc.data(), documentId: doc.id))
        .toList();
  }

  // --- LIKES ---

  Future<void> alternarLike(String idPost, String uidUsuario) async {
    final docRef = _db.collection('publicaciones').doc(idPost);
    final doc = await docRef.get();

    if (!doc.exists) return;

    final List<String> likes = List<String>.from(doc.data()?['likes'] ?? []);

    if (likes.contains(uidUsuario)) {
      likes.remove(uidUsuario);
    } else {
      likes.add(uidUsuario);
    }

    await docRef.update({'likes': likes});
  }

  // --- COMENTARIS ---

  Future<void> afegirComentari(Comentario comentari) async {
    // Afegir el comentari
    await _db.collection('comentarios').add(comentari.toMap());

    // Incrementar el contador a la publicació (opcional però recomanat per performance)
    final docRef = _db.collection('publicaciones').doc(comentari.idPublicacion);
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;
      int currentCount = snapshot.data()?['comentariosCount'] ?? 0;
      transaction.update(docRef, {'comentariosCount': currentCount + 1});
    });
  }

  Stream<List<Comentario>> obtenerComentarios(String idPost) {
    return _db
        .collection('comentarios')
        .where('idPublicacion', isEqualTo: idPost)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Comentario.fromMap(doc.data(), documentId: doc.id))
          .toList();
    });
  }
}
