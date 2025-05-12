
import 'dart:async';

import 'package:alfred/alfred.dart';

FutureOr validateGetIdMiddleware(HttpRequest req, HttpResponse res)  {
  // Parsear el cuerpo de la solicitud como un Map<String, dynamic>

  final params = req.params;

  // Extraer los campos email y password
  final id = params['id'] as String?;

  // Validar que ambos campos existan
  if (id == null || id.isEmpty) {
      throw AlfredException(400, {'error': 'El id es requerido'});
  }
}