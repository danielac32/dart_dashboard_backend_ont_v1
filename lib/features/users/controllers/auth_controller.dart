


import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:dart_dashboard_backend_ont_v1/features/users/services/user_service.dart';

import '../../../config/jwt.dart';
import '../interfaces/update_request.dart';

class AuthController {
      final UserService _userService;
      AuthController(this._userService);

      Future<Map<String, dynamic>> login(HttpRequest request, HttpResponse response) async {
        try {
          final body = await request.bodyAsJsonMap;
          final user = await _userService.login(
            body['email'] as String,
            body['password'] as String,
          );

          if (user == null) {
            throw AlfredException(HttpStatus.unprocessableEntity, {'error': 'Credenciales inválidas'});
          }

          final token = generateJWT(body['email']);
          return {
            'success': true,
            'user': user,
            'token': token,
          };
        } catch (e) {
          // Esto evita que Alfred envíe su propio manejo de errores si ya has respondido
          throw AlfredException(HttpStatus.internalServerError, {'error': e.toString()});
        }
      }

      Future<Map<String, dynamic>> register(HttpRequest request, HttpResponse response) async {
        try {
          final body = await request.bodyAsJsonMap;
          final dynamicRequest = DynamicRequest(body);

          final existingUser = await _userService.getByEmail(dynamicRequest.call('email').trim());
          if (existingUser != null) {
            throw AlfredException(
              HttpStatus.conflict,
              {'error': 'Ya existe un usuario con este correo electrónico.'},
            );
          }


          final register = await _userService.register(
              email: dynamicRequest.call('email'),
              password: dynamicRequest.call('password'),
              name: dynamicRequest.call('name'),
              department: dynamicRequest.call('department'),
              role: dynamicRequest.call('role'),
              position: dynamicRequest.call('position'),
              profileImage: dynamicRequest.call('profileImage')
          );

          if (register > 0) {
            return {
              'success': true,
              'message': 'Usuario registrado exitosamente',
            };
          } else {
            throw AlfredException(
              HttpStatus.badRequest,
              {'error': 'Error al registrar el usuario.'},
            );
          }

        } catch (e) {
          if (e is AlfredException) rethrow;

          throw AlfredException(
            HttpStatus.internalServerError,
            {'error': e.toString()},
          );
        }
      }

}