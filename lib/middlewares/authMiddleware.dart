import 'dart:io';

import 'package:alfred/alfred.dart';

import '../config/jwt.dart';


// Middleware de autenticación
Future<void> authMiddleware(HttpRequest req, HttpResponse res) async {
  try {
    final authHeader = req.headers.value('Authorization');
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      throw AlfredException(HttpStatus.unauthorized, {'message': 'Token no proporcionado'});
    }

    final token = authHeader.replaceFirst('Bearer ', '');
    if (!validateJWT(token)) {
      throw AlfredException(HttpStatus.unauthorized, {'message': 'Token inválido o expirado'});
    }
  } catch (e) {
    throw AlfredException(HttpStatus.unauthorized, {'message': 'unauthorized'});
  }
}