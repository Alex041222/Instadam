import 'package:flutter/material.dart';

class IdiomaController {
  static final IdiomaController instancia = IdiomaController._();
  IdiomaController._();

  final ValueNotifier<String> idioma = ValueNotifier("es");
}
