import 'dart:async';

import 'package:alfred/alfred.dart';

import '../interfaces/update_request.dart';


FutureOr validateUpdateMiddleware(HttpRequest req, HttpResponse res) async {


  /*
  final body = await req.bodyAsJsonMap;
  final dynamicRequest = DynamicRequest( body);
  dynamicRequest.validate(['email', 'password', 'name','role','department','position']);
   */
  final body = await req.bodyAsJsonMap;
  final dynamicRequest = DynamicRequest( body);


  if(dynamicRequest.call("email")!=null){
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(dynamicRequest.call("email"))) {
      throw AlfredException(400, {'error': 'El formato del correo electrónico es inválido'});
    }
  }
  if(dynamicRequest.call("password")!=null){
    if (dynamicRequest.call("password").length < 6) {
      throw AlfredException(400, {'error': 'contraseña menor a 6'});
    }
    if (dynamicRequest.call("password").isEmpty) {
      throw AlfredException(400, {'error': 'campo password requeridos'});
    }
  }
  if(dynamicRequest.call("position")!=null){
    if (dynamicRequest.call("position").isEmpty) {
      throw AlfredException(400, {'error': 'campo position requeridos'});
    }
  }
  /*if(dynamicRequest.call("isActive")!=null){
    if (dynamicRequest.call("isActive") != true || dynamicRequest.call("isActive") != false) {
      throw AlfredException(400, {'error': 'campo isActive requeridos'});
    }
  }*/
  /*if(dynamicRequest.call("profileImage")!=null){
    if (dynamicRequest.call("profileImage").isEmpty) {
      throw AlfredException(400, {'error': 'campo profileImage requeridos'});
    }
  }*/
  if(dynamicRequest.call("role")!=null){
    if (dynamicRequest.call("role").isEmpty) {
      throw AlfredException(400, {'error': 'campo role requeridos'});
    }
  }
  if(dynamicRequest.call("name")!=null){
    if (dynamicRequest.call("name").isEmpty) {
      throw AlfredException(400, {'error': 'campo name requeridos'});
    }
  }
  if(dynamicRequest.call("department")!=null){
    if (dynamicRequest.call("department").isEmpty) {
      throw AlfredException(400, {'error': 'campo department requeridos'});
    }
  }

}

