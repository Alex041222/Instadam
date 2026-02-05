import 'package:shared_preferences/shared_preferences.dart';

class ServicioPerfil {
  static final ServicioPerfil instancia = ServicioPerfil._();
  ServicioPerfil._();

  Future<void> guardarNombre(String nombre) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('perfil_nombre', nombre);
  }

  Future<String?> obtenerNombre() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('perfil_nombre');
  }

  Future<void> guardarFoto(String ruta) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('perfil_foto', ruta);
  }

  Future<String?> obtenerFoto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('perfil_foto');
  }
}
