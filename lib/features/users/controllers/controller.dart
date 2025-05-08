import 'dart:async';
import 'package:alfred/alfred.dart';
import 'package:dart_dashboard_backend_ont_v1/features/users/interfaces/register_response.dart';
import 'package:dart_dashboard_backend_ont_v1/features/users/services/user_service.dart';
import 'package:dart_dashboard_backend_ont_v1/model/model.dart';

class AuthController{
  final UserService _userService;
  AuthController(this._userService);

  Future<Map<String, dynamic>> login(HttpRequest request, HttpResponse response) async {
     return {
       "msg":"login"

     };
  }

  Future<Map<String, dynamic>> register(HttpRequest request, HttpResponse response) async {
    final body = await request.bodyAsJsonMap;
    final userRequest= RegisterResponse.fromJson(body);
    final register= await _userService.register(
      email: userRequest.email,
      password: userRequest.password,
      name: userRequest.name,
      department: userRequest.department,
      role: userRequest.role,
    );
    return {
      'success': true,
      'message': 'Usuario registrado exitosamente',
    };
  }

  Future<Map<String, dynamic>> list(HttpRequest request, HttpResponse response) async{
    final users= await _userService.getUsersByFilter();
    return{
      'success': true,
      'users': users
    };
  }
}
