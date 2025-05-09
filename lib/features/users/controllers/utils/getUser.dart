

import 'package:alfred/alfred.dart';
import 'package:dart_dashboard_backend_ont_v1/model/model.dart';
import 'dart:io';
import '../../services/user_service.dart';

Future<User> getUserByIdEmail(UserService userService,String userId) async{
  final user = await userService.getByIdEmail(userId);
  if (user == null) {
    throw AlfredException(HttpStatus.notFound, {'error': 'Usuario no encontrado'});
  }
  return user;
}