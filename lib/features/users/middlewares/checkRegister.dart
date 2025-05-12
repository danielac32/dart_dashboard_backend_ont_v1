
import 'dart:async';

import 'package:alfred/alfred.dart';

import '../interfaces/update_request.dart';







FutureOr validateRegisterMiddleware(HttpRequest req, HttpResponse res) async {

  final body = await req.bodyAsJsonMap;
  final dynamicRequest = DynamicRequest( body);
  dynamicRequest.validate(['email', 'password', 'name','role','department','position']);
  /*// Parsear el cuerpo de la solicitud como un Map<String, dynamic>
  final body = await req.bodyAsJsonMap;

  // Extraer los campos email y password
  final email = body['email'] as String?;
  final password = body['password'] as String?;
  final role = body['role'] as String?;
  final name = body['name'] as String?;
  final department = body['department'] as String?;
  final position = body['position'] as String?;


  // Validar que ambos campos existan
  if (email == null || email.isEmpty) {
    throw AlfredException(400, {'error': 'campo email requeridos'});
  }
  if (password == null || password.isEmpty) {
    throw AlfredException(400, {'error': 'campo password requeridos'});
  }
  if (role == null || role.isEmpty) {
    throw AlfredException(400, {'error': 'campo role requeridos'});
  }
  if (name == null || name.isEmpty) {
    throw AlfredException(400, {'error': 'campo name requeridos'});
  }
  if (department == null || department.isEmpty) {
    throw AlfredException(400, {'error': 'campo department requeridos'});
  }
  if (position == null || position.isEmpty) {
    throw AlfredException(400, {'error': 'campo cargo requeridos'});
  }
  // Validar el formato del correo electrónico
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
    throw AlfredException(400, {'error': 'El formato del correo electrónico es inválido'});
  }*/
}

FutureOr checkPassWordLengthMiddleware(HttpRequest req, HttpResponse res) async {
  // Parsear el cuerpo de la solicitud como un Map<String, dynamic>
  final body = await req.bodyAsJsonMap;
  //final email = body['email'] as String?;
  final password = body['password'] as String?;

  if (password == null || password.isEmpty) {
    throw AlfredException(400, {'error': 'campo password requeridos'});
  }
  if (password.length < 6) {
    throw AlfredException(400, {'error': 'contraseña menor a 6'});
  }

}
