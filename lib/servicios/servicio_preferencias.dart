import 'package:shared_preferences/shared_preferences.dart';

class ServicioPreferencias {
  static final ServicioPreferencias instancia = ServicioPreferencias._();
  ServicioPreferencias._();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Tema
  bool get temaOscuro => _prefs?.getBool('temaOscuro') ?? false;
  set temaOscuro(bool valor) => _prefs?.setBool('temaOscuro', valor);

  // Notificaciones
  bool get notificaciones => _prefs?.getBool('notificaciones') ?? true;
  set notificaciones(bool valor) => _prefs?.setBool('notificaciones', valor);

  // Idioma
  String get idioma => _prefs?.getString('idioma') ?? 'es';
  set idioma(String valor) => _prefs?.setString('idioma', valor);

  // Recordar usuario
  bool get recordarUsuario => _prefs?.getBool('recordarUsuario') ?? false;
  set recordarUsuario(bool valor) => _prefs?.setBool('recordarUsuario', valor);

  // Guardar usuario (si el tens implementat)
  set usuarioGuardado(String? valor) =>
      _prefs?.setString('usuarioGuardado', valor ?? "");

  String? get usuarioGuardado =>
      _prefs?.getString('usuarioGuardado');

  // Cerrar sesión (sense esborrar tema/idioma)
  Future<void> cerrarSesion() async {
    await _prefs?.remove('recordarUsuario');
    await _prefs?.remove('usuarioGuardado');
  }
}
