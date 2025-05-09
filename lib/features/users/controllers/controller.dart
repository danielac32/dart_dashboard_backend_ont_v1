import 'dart:async';
import 'package:alfred/alfred.dart';
import 'package:dart_dashboard_backend_ont_v1/features/users/controllers/utils/getUser.dart';
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
/**********************************************************************************************************************/
  Future<Map<String, dynamic>> getPermissionsByUser(HttpRequest request, HttpResponse response) async {

    final userId = request.params['id'];
    User user = await getUserByIdEmail(_userService,userId);
    final permissions = await _userService.getPermissionsByUser(user.id);

    return {
      'success': true,
      'permissions': permissions
    };
  }

  Future<Map<String, dynamic>> addPermissionToUser(HttpRequest request, HttpResponse response) async {
    final userId = request.params['id'];
    final body= await request.bodyAsJsonMap;
    User user = await getUserByIdEmail(_userService,userId);
    final dynamicRequest = DynamicRequest( body);
    final permiso = Permission(
      section: dynamicRequest.call('section'),
      canCreate: dynamicRequest.call('canCreate'),
      canEdit: dynamicRequest.call('canEdit'),
      canDelete: dynamicRequest.call('canDelete'),
      canPublish:dynamicRequest.call('canPublish'),
    );
    permiso.user.target=user;
    final success = _userService.addPermissionToUser(user.id, permiso);
    if (!success) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Failed to add permission'});
    }
    return {
      'success': true,
      'message': 'Permission added successfully',
    };
  }

  Future<Map<String, dynamic>> removePermissionFromUser(HttpRequest request, HttpResponse response) async {

    final userId = request.params['id'];
    User user = await getUserByIdEmail(_userService,userId);
    final permissionId = int.parse(request.params['permissionId']!);

    final success = _userService.removePermissionFromUser(user.id, permissionId);
    if (!success) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Failed to remove permission'});
    }
    return {
      'success': true,
      'message': 'Permission removed successfully',
    };

  }

  // Métodos similares para organismos, programaciones, resúmenes y noticias...

  // Organismos
  Future<Map<String, dynamic>> getOrganismosByUser(HttpRequest request, HttpResponse response) async {
    /*final userId = int.parse(request.params['id']!);
    final organismos = _userService.getOrganismosByUser(userId);
    return {
      'success': true,
      'organismos': organismos.map((o) => o.toJson()).toList(),
    };*/
    return {
      'success': true,
    };
  }

  Future<Map<String, dynamic>> addOrganismoToUser(HttpRequest request, HttpResponse response) async {
    /*final userId = int.parse(request.params['id']!);
    final body = await request.bodyAsJsonMap;
    final organismo = OrganismoGobernacion.fromJson(body);

    final success = _userService.addOrganismoToUser(userId, organismo);
    if (!success) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Failed to add organismo'});
    }
    return {
      'success': true,
      'message': 'Organismo added successfully',
    };*/
    return {
      'success': true,
    };
  }

  Future<Map<String, dynamic>> removeOrganismoFromUser(HttpRequest request, HttpResponse response) async {
    /*final userId = int.parse(request.params['id']!);
    final organismoId = int.parse(request.params['organismoId']!);

    final success = _userService.removeOrganismoFromUser(userId, organismoId);
    if (!success) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Failed to remove organismo'});
    }
    return {
      'success': true,
      'message': 'Organismo removed successfully',
    };*/
    return {
      'success': true,
    };
  }

  // Programaciones Financieras
  Future<Map<String, dynamic>> getProgramacionesByUser(HttpRequest request, HttpResponse response) async {
    /*final userId = int.parse(request.params['id']!);
    final programaciones = _userService.getProgramacionesByUser(userId);
    return {
      'success': true,
      'programaciones': programaciones.map((p) => p.toJson()).toList(),
    };*/
    return {
      'success': true,
    };
  }

  Future<Map<String, dynamic>> addProgramacionToUser(HttpRequest request, HttpResponse response) async {
    /*final userId = int.parse(request.params['id']!);
    final body = await request.bodyAsJsonMap;
    final programacion = ProgramacionFinanciera.fromJson(body);

    final success = _userService.addProgramacionToUser(userId, programacion);
    if (!success) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Failed to add programación'});
    }
    return {
      'success': true,
      'message': 'Programación added successfully',
    };*/
    return {
      'success': true,
    };
  }

  Future<Map<String, dynamic>> removeProgramacionFromUser(HttpRequest request, HttpResponse response) async {
    /*final userId = int.parse(request.params['id']!);
    final programacionId = int.parse(request.params['programacionId']!);

    final success = _userService.removeProgramacionFromUser(userId, programacionId);
    if (!success) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Failed to remove programación'});
    }
    return {
      'success': true,
      'message': 'Programación removed successfully',
    };*/
    return {
      'success': true,
    };
  }

  // Resúmenes de Gestión
  Future<Map<String, dynamic>> getResumenesByUser(HttpRequest request, HttpResponse response) async {
    /*final userId = int.parse(request.params['id']!);
    final resumenes = _userService.getResumenesByUser(userId);
    return {
      'success': true,
      'resumenes': resumenes.map((r) => r.toJson()).toList(),
    };*/
    return {
      'success': true,
    };
  }

  Future<Map<String, dynamic>> addResumenToUser(HttpRequest request, HttpResponse response) async {
   /* final userId = int.parse(request.params['id']!);
    final body = await request.bodyAsJsonMap;
    final resumen = ResumenGestion.fromJson(body);

    final success = _userService.addResumenToUser(userId, resumen);
    if (!success) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Failed to add resumen'});
    }
    return {
      'success': true,
      'message': 'Resumen added successfully',
    };*/
    return {
      'success': true,
    };
  }

  Future<Map<String, dynamic>> removeResumenFromUser(HttpRequest request, HttpResponse response) async {
    /*final userId = int.parse(request.params['id']!);
    final resumenId = int.parse(request.params['resumenId']!);

    final success = _userService.removeResumenFromUser(userId, resumenId);
    if (!success) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Failed to remove resumen'});
    }
    return {
      'success': true,
      'message': 'Resumen removed successfully',
    };*/
    return {
      'success': true,
    };
  }

  // Noticias
  Future<Map<String, dynamic>> getNoticiasByUser(HttpRequest request, HttpResponse response) async {
    /*final userId = int.parse(request.params['id']!);
    final noticias = _userService.getNoticiasByUser(userId);
    return {
      'success': true,
      'noticias': noticias.map((n) => n.toJson()).toList(),
    };*/
    return {
      'success': true,
    };
  }

  Future<Map<String, dynamic>> addNoticiaToUser(HttpRequest request, HttpResponse response) async {
   /* final userId = int.parse(request.params['id']!);
    final body = await request.bodyAsJsonMap;
    final noticia = Noticia.fromJson(body);

    final success = _userService.addNoticiaToUser(userId, noticia);
    if (!success) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Failed to add noticia'});
    }
    return {
      'success': true,
      'message': 'Noticia added successfully',
    };*/
    return {
      'success': true,
    };
  }

  Future<Map<String, dynamic>> removeNoticiaFromUser(HttpRequest request, HttpResponse response) async {
    /*final userId = int.parse(request.params['id']!);
    final noticiaId = int.parse(request.params['noticiaId']!);

    final success = _userService.removeNoticiaFromUser(userId, noticiaId);
    if (!success) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Failed to remove noticia'});
    }
    return {
      'success': true,
      'message': 'Noticia removed successfully',
    };*/
    return {
      'success': true,
    };
  }
}


