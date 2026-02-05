import 'package:flutter/material.dart';

class TemaController {
  static final TemaController instancia = TemaController._();
  TemaController._();

  final ValueNotifier<bool> temaOscuro = ValueNotifier(false);
}
