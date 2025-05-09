import 'dart:async';
import 'package:alfred/alfred.dart';
import 'package:dart_dashboard_backend_ont_v1/features/users/interfaces/register_request.dart';
import 'package:dart_dashboard_backend_ont_v1/features/users/services/user_service.dart';
import 'package:dart_dashboard_backend_ont_v1/model/model.dart';
import 'dart:io';
import '../../../config/jwt.dart';
import '../interfaces/update_request.dart';

class AuthController{
  final UserService _userService;
  AuthController(this._userService);

  Future<Map<String, dynamic>> login(HttpRequest request, HttpResponse response) async {
    final body = await request.bodyAsJsonMap;
    final user = await _userService.login(
      body['email'] as String,
      body['password'] as String,
    );

    if (user == null) {
      throw AlfredException(HttpStatus.unprocessableEntity, {'error': 'Credenciales inválidas'});//422 Unprocessable Entity
    }

    final token = generateJWT(body['email']);
    return {
      'success': true,
      'user': user,//.toJson(),
      'token': token, // Implementar JWT aquí
    };
  }

  Future<Map<String, dynamic>> register(HttpRequest request, HttpResponse response) async {
    final body = await request.bodyAsJsonMap;
    final userRequest= RegisterRequest.fromJson(body);
    User? user= await _userService.getByEmail(userRequest.email);
    if(user!=null){
      /*return {
        'success': false,
        'message': 'El Usuario ya existe',
      };*/
      throw AlfredException(HttpStatus.conflict, {'error': 'El Usuario ya existe'});
    }

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
    if(users.isEmpty){
      return{
        'success': true,
        'users': 0
      };
    }
    return{
      'success': true,
      'users': users
    };
  }

  Future <Map<String,dynamic>> updateById(HttpRequest request, HttpResponse response) async{
    final body = await request.bodyAsJsonMap;
    final dynamicRequest = DynamicRequest( body);
    final id = request.params['id'];

    final user = await _userService.getByIdEmail(id);
    if (user == null) {
      /*response.statusCode = 404;
      return {'success': false, 'error': 'Usuario no encontrado'};*/
      throw AlfredException(HttpStatus.notFound, {'error': 'Usuario no encontrado'});
    }

    final userUpdate=user.copyWith( name: dynamicRequest.call("name"),
                                    email: dynamicRequest.call("email"),
                                    role: dynamicRequest.call("role"),
                                    department: dynamicRequest.call("department"),
                                    password: dynamicRequest.call("password")
                                );

    print(userUpdate.toJson());
    final f= _userService.update(userUpdate);
   // user.name=dynamicRequest.call("name");

    //print(id);
    //dynamicRequest.validate(['email', 'password', 'name']);

   // print(dynamicRequest.call("email"));
   // print(dynamicRequest.call("name"));
    //print(dynamicRequest.call("password"));
   // print(dynamicRequest.call("role"));

    return{
      'success': f?true:false,
      'user':userUpdate
    };
  }



  Future <Map<String,dynamic>> deleteById(HttpRequest request, HttpResponse response) async{
    final params = request.params;
    final id = request.params['id'];

    final user = await _userService.getByIdEmail(id);
    if (user == null) {
      throw AlfredException(HttpStatus.notFound, {'error': 'Usuario no encontrado'});
    }
    final f = _userService.delete(user.id);

    return{
      'success': f?true:false,
      'user':user
    };
  }


  Future <Map<String, dynamic>> getById(HttpRequest request, HttpResponse response) async{
    final params = request.params;
    final id = params['id'] as String?;
    final user;

    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(id!)) {
          user=  await _userService.getById(int.tryParse(id)!);
    }else {
          user= await _userService.getByEmail(id);
    }
    if (user == null) {
      throw AlfredException(HttpStatus.notFound, {'error': 'Usuario no encontrado'});
    }
    return{
      'success': true,
      'users': user.toJson()
    };
  }
}
