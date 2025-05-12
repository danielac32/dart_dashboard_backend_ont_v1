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
    final dynamicRequest = DynamicRequest( body);
    User? user= await _userService.getByEmail(dynamicRequest.call('email'));
    if(user!=null){
      throw AlfredException(HttpStatus.conflict, {'error': 'El Usuario ya existe'});
    }

    final register= await _userService.register(
      email: dynamicRequest.call('email'),
      password: dynamicRequest.call('password'),
      name: dynamicRequest.call('name'),
      department: dynamicRequest.call('department'),
      role: dynamicRequest.call('role'),
      position: dynamicRequest.call('position'),
    );
    if(register>0){
      return {
        'success': true,
        'message': 'Usuario registrado exitosamente',
      };
    }

    throw AlfredException(HttpStatus.badRequest, {'error': 'Error al registrar'});
  }


/*
  Future<Map<String, dynamic>> getPaginator(HttpRequest request, HttpResponse response) async{
    final users= await _userService.getUsersByFilter();


  }

 */


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

    /*final user = await _userService.getByIdEmail(id);
    if (user == null) {
      throw AlfredException(HttpStatus.notFound, {'error': 'Usuario no encontrado'});
    }*/
    User user = await getUserByIdEmail(_userService,id);

    final f = _userService.delete(user.id);

    return{
      'success': f?true:false,
      'user':user
    };
  }


  Future <Map<String, dynamic>> getById(HttpRequest request, HttpResponse response) async{
    final params = request.params;
    final id = params['id'];
   // final user;

    User user = await getUserByIdEmail(_userService,id);

   /* if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(id!)) {
          user=  await _userService.getById(int.tryParse(id)!);
    }else {
          user= await _userService.getByEmail(id);
    }
    if (user == null) {
      throw AlfredException(HttpStatus.notFound, {'error': 'Usuario no encontrado'});
    }*/
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

    final userId = request.params['id'];
    User user = await getUserByIdEmail(_userService,userId);

    final organismos = await _userService.getOrganismosByUser(user.id);
    //final organismosJson = organismos.map((org) => org.toJson()).toList();

    return {
      'success': true,
      'organismos': organismos
    };
  }

  Future<Map<String, dynamic>> addOrganismoToUser(HttpRequest request, HttpResponse response) async {

    final userId = request.params['id'];
    final body= await request.bodyAsJsonMap;
    User user = await getUserByIdEmail(_userService,userId);
    final dynamicRequest = DynamicRequest( body);
    final organismo = OrganismoGobernacion(
      nombre: dynamicRequest.call('nombre'),
      valor1: dynamicRequest.call('valor1'),
      valor2: dynamicRequest.call('valor2'),
      valor3: dynamicRequest.call('valor3'),
    );
    organismo.autor.target=user;
    final success = _userService.addOrganismoToUser(user.id, organismo);
    if (!success) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Failed to add Organismo'});
    }
    return {
      'success': true,
      'message': 'Organismo added successfully',
    };

  }

  Future<Map<String, dynamic>> removeOrganismoFromUser(HttpRequest request, HttpResponse response) async {
    final userId = request.params['id'];
    User user = await getUserByIdEmail(_userService,userId);
    final organismoId = int.parse(request.params['organismoId']!);

    final success = _userService.removeOrganismoFromUser(user.id, organismoId);
    if (!success) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Failed to remove organismo'});
    }
    return {
      'success': true,
      'message': 'Organismo removed successfully',
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
    final userId = request.params['id'];

    // Obtener el usuario por su ID o correo electrónico
    User user = await getUserByIdEmail(_userService, userId);

    // Obtener los resúmenes asociados al usuario
    final resumenes = await _userService.getResumenesByUser(user.id);

    // Retornar la respuesta con los resúmenes
    return {
      'success': true,
      'resumenes': resumenes
    };
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

    final userId = request.params['id'];
    // Obtener el cuerpo de la solicitud como un mapa JSON
    final body = await request.bodyAsJsonMap;
    // Obtener el usuario por su ID o correo electrónico
    User user = await getUserByIdEmail(_userService, userId);

    // Crear una instancia de ResumenGestion a partir del cuerpo de la solicitud
    final dynamicRequest = DynamicRequest(body);
    final resumen = ResumenGestion(
      titulo: dynamicRequest.call('titulo'),
      descripcion: dynamicRequest.call('descripcion'),
      imagenUrl: dynamicRequest.call('imagenUrl'),
    );
    // Agregar el resumen al usuario
    final success = _userService.addResumenToUser(user.id, resumen);

    // Verificar si la operación fue exitosa
    if (!success) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Failed to add resumen'});
    }

    // Retornar la respuesta de éxito
    return {
      'success': true,
      'message': 'Resumen added successfully',
    };
  }

  Future<Map<String, dynamic>> removeResumenFromUser(HttpRequest request, HttpResponse response) async {

    final userId = request.params['id'];

    // Obtener el ID del resumen a eliminar
    final resumenId = int.tryParse(request.params['resumenId'] ?? '');
    if (resumenId == null) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Resumen ID is required and must be a valid integer'});
    }
    // Obtener el usuario por su ID o correo electrónico
    User user = await getUserByIdEmail(_userService, userId);

    // Eliminar el resumen del usuario
    final success = _userService.removeResumenFromUser(user.id, resumenId);

    // Verificar si la operación fue exitosa
    if (!success) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Failed to remove resumen'});
    }
    // Retornar la respuesta de éxito
    return {
      'success': true,
      'message': 'Resumen removed successfully',
    };
  }

  // Noticias
  Future<Map<String, dynamic>> getNoticiasByUser(HttpRequest request, HttpResponse response) async {
    final userId = request.params['id'];
    // Obtener el usuario por su ID o correo electrónico
    User user = await getUserByIdEmail(_userService, userId);

    // Obtener las noticias asociadas al usuario
    final noticias = _userService.getNoticiasByUser(user.id);

    // Retornar la respuesta con las noticias
    return {
      'success': true,
      'noticias': noticias
    };
    return {
      'success': true,
    };
  }

  Future<Map<String, dynamic>> addNoticiaToUser(HttpRequest request, HttpResponse response) async {
    final userId = request.params['id'];
    // Obtener el cuerpo de la solicitud como un mapa JSON
    final body = await request.bodyAsJsonMap;
    // Obtener el usuario por su ID o correo electrónico
    User user = await getUserByIdEmail(_userService, userId);

    // Crear una instancia de Noticia a partir del cuerpo de la solicitud
    final dynamicRequest = DynamicRequest(body);
    final noticia = Noticia(
      titulo: dynamicRequest.call('titulo'),
      contenido: dynamicRequest.call('contenido'),
      imagenUrl: dynamicRequest.call('imagenUrl')
    );

    // Agregar la noticia al usuario
    final success = _userService.addNoticiaToUser(user.id, noticia);

    // Verificar si la operación fue exitosa
    if (!success) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Failed to add noticia'});
    }

    // Retornar la respuesta de éxito
    return {
      'success': true,
      'message': 'Noticia added successfully',
    };

  }

  Future<Map<String, dynamic>> removeNoticiaFromUser(HttpRequest request, HttpResponse response) async {

    final userId = request.params['id'];
    // Obtener el ID de la noticia a eliminar
    final noticiaId = int.tryParse(request.params['noticiaId'] ?? '');

    if (noticiaId == null) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Noticia ID is required and must be a valid integer'});
    }

    // Obtener el usuario por su ID o correo electrónico
    User user = await getUserByIdEmail(_userService, userId);

    // Eliminar la noticia del usuario
    final success = _userService.removeNoticiaFromUser(user.id, noticiaId);

    // Verificar si la operación fue exitosa
    if (!success) {
      throw AlfredException(HttpStatus.badRequest, {'error': 'Failed to remove noticia'});
    }

    // Retornar la respuesta de éxito
    return {
      'success': true,
      'message': 'Noticia removed successfully',
    };
  }
}


