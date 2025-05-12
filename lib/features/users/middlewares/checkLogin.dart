
import 'dart:async';

import 'package:alfred/alfred.dart';

FutureOr validateLoginMiddleware(HttpRequest req, HttpResponse res) async {
  // Parsear el cuerpo de la solicitud como un Map<String, dynamic>
  final body = await req.bodyAsJsonMap;

  // Extraer los campos email y password
  final email = body['email'] as String?;
  final password = body['password'] as String?;

  // Validar que ambos campos existan
  if (email == null || password == null) {
    throw AlfredException(400, {'error': 'Los campos email y password son requeridos'});
  }
  // Validar el formato del correo electrónico
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
    throw AlfredException(400, {'error': 'El formato del correo electrónico es inválido'});
  }
}