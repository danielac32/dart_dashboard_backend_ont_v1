

import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:dart_dashboard_backend_ont_v1/model/model.dart';
import 'package:dart_dashboard_backend_ont_v1/utils/DireccionCargoRole/services/dcr_services.dart';

import '../../../features/users/interfaces/update_request.dart';

class DireccionController{
final DireccionService _direccionService;
DireccionController(this._direccionService);

Future<Map<String, dynamic>>create(HttpRequest request, HttpResponse response) async {
    final body = await request.bodyAsJsonMap;
    final dynamicRequest = DynamicRequest( body);
    bool exist = await _direccionService.exist(dynamicRequest.call('name'));
    if(exist){
      throw AlfredException(HttpStatus.conflict, {'error': 'La direccion ya existe'});
    }
    final dir = Direccion(name: dynamicRequest.call('name'));
    final set = await _direccionService.create(dir);

    if(set>0){
      return {
        'success': true,
        'message': 'Direccion registrada exitosamente',
      };
    }
    throw AlfredException(HttpStatus.badRequest, {'error': 'Error al registrar'});
}

Future<Map<String,dynamic>> list(HttpRequest request, HttpResponse response) async {
   final direcciones = await _direccionService.get();
   if(direcciones.isEmpty){
     return{
       'success': true,
       'direcciones': 0
     };
   }
   return{
     'success': true,
     'direcciones': direcciones
   };
}
Future<Map<String,dynamic>>getById(HttpRequest request, HttpResponse response) async {
  final params = request.params;
  final id = params['id'];
  Direccion? dir = await _direccionService.getById(int.tryParse(id)??0);

  return{
    'success': true,
    'direccion': dir?.toJson()
  };
}
Future<Map<String,dynamic>>updateById(HttpRequest request, HttpResponse response) async {
  final params = request.params;
  final id = params['id'];
  final body= await request.bodyAsJsonMap;
  final dynamicRequest = DynamicRequest( body);
  bool exist = await _direccionService.exist(dynamicRequest.call('name'));
  if(!exist){
    throw AlfredException(HttpStatus.conflict, {'error': 'La direccion no existe'});
  }
  Direccion? dir = await _direccionService.getById(int.tryParse(id)??0);
  dir?.copyWith(name: dynamicRequest.call('name'));
  bool direccionUpdate= await _direccionService.update(dir!);

  return{
    'success': direccionUpdate,
    'user':dir
  };
}


Future<Map<String,dynamic>>deleteById(HttpRequest request, HttpResponse response) async {
  final params = request.params;
  final id = params['id'];
  Direccion? dir = await _direccionService.getById(int.tryParse(id)??0);
  if(dir == null){
    throw AlfredException(HttpStatus.conflict, {'error': 'La direccion no existe'});
  }
  bool dirDelete= await _direccionService.delete(dir.id);
  return{
    'success': dirDelete,
    'user':dir
  };
}

/****************************************************************************************************/

}

class CargoController{
  final CargoService _cargoService;
  CargoController(this._cargoService);

  Future<Map<String, dynamic>>create(HttpRequest request, HttpResponse response) async {
    final body = await request.bodyAsJsonMap;
    final dynamicRequest = DynamicRequest( body);
    bool exist = await _cargoService.exist(dynamicRequest.call('name'));
    if(exist){
      throw AlfredException(HttpStatus.conflict, {'error': 'La cargo ya existe'});
    }
    final cargo = Cargo(name: dynamicRequest.call('name'));
    final set = await _cargoService.create(cargo);

    if(set>0){
      return {
        'success': true,
        'message': 'Cargo registrada exitosamente',
      };
    }
    throw AlfredException(HttpStatus.badRequest, {'error': 'Error al registrar'});
  }

  Future<Map<String,dynamic>> list(HttpRequest request, HttpResponse response) async {
    final cargos = await _cargoService.get();
    if(cargos.isEmpty){
      return{
        'success': false,
        'cargos': 0
      };
    }
    return{
      'success': true,
      'cargos': cargos
    };
  }
  Future<Map<String,dynamic>>getById(HttpRequest request, HttpResponse response) async {
    final params = request.params;
    final id = params['id'];
    Cargo? cargo = await _cargoService.getById(int.tryParse(id)??0);

    return{
      'success': true,
      'cargo': cargo?.toJson()
    };
  }

  Future<Map<String,dynamic>>updateById(HttpRequest request, HttpResponse response) async {
    final params = request.params;
    final id = params['id'];
    final body= await request.bodyAsJsonMap;
    final dynamicRequest = DynamicRequest( body);
    bool exist = await _cargoService.exist(dynamicRequest.call('name'));
    if(!exist){
      throw AlfredException(HttpStatus.conflict, {'error': 'El cargo no existe'});
    }
    Cargo? cargo = await _cargoService.getById(int.tryParse(id)??0);
    cargo?.copyWith(name: dynamicRequest.call('name'));
    bool cargoUpdate= await _cargoService.update(cargo!);

    return{
      'success': cargoUpdate,
      'user':cargo
    };
  }


  Future<Map<String,dynamic>>deleteById(HttpRequest request, HttpResponse response) async {
    final params = request.params;
    final id = params['id'];
    Cargo? cargo = await _cargoService.getById(int.tryParse(id)??0);
    if(cargo == null){
      throw AlfredException(HttpStatus.conflict, {'error': 'El cargo no existe'});
    }
    bool cargoDelete= await _cargoService.delete(cargo.id);
    return{
      'success': cargoDelete,
      'user':cargo
    };
  }
}

/******************************************************************************************************/

class RoleController{
  final RoleService _roleService;
  RoleController(this._roleService);

  Future<Map<String, dynamic>>create(HttpRequest request, HttpResponse response) async {
    final body = await request.bodyAsJsonMap;
    final dynamicRequest = DynamicRequest( body);
    bool exist = await _roleService.exist(dynamicRequest.call('name'));
    if(exist){
      throw AlfredException(HttpStatus.conflict, {'error': 'El Role ya existe'});
    }
    final role = Role(name: dynamicRequest.call('name'));
    final set = await _roleService.create(role);

    if(set>0){
      return {
        'success': true,
        'message': 'Role registrado exitosamente',
      };
    }
    throw AlfredException(HttpStatus.badRequest, {'error': 'Error al registrar'});
  }

  Future<Map<String,dynamic>> list(HttpRequest request, HttpResponse response) async {
    final roles = await _roleService.get();
    if(roles.isEmpty){
      return{
        'success': false,
        'roles': 0
      };
    }
    return{
      'success': true,
      'roles': roles
    };
  }

  Future<Map<String,dynamic>>getById(HttpRequest request, HttpResponse response) async {
    final params = request.params;
    final id = params['id'];
    Role? role = await _roleService.getById(int.tryParse(id)??0);

    return{
      'success': true,
      'role': role?.toJson()
    };
  }

  Future<Map<String,dynamic>>updateById(HttpRequest request, HttpResponse response) async {
    final params = request.params;
    final id = params['id'];
    final body= await request.bodyAsJsonMap;
    final dynamicRequest = DynamicRequest( body);
    bool exist = await _roleService.exist(dynamicRequest.call('name'));
    if(!exist){
      throw AlfredException(HttpStatus.conflict, {'error': 'El role no existe'});
    }
    Role? role = await _roleService.getById(int.tryParse(id)??0);
    role?.copyWith(name: dynamicRequest.call('name'));
    bool roleUpdate= await _roleService.update(role!);

    return{
      'success': roleUpdate,
      'rol':role
    };
  }


  Future<Map<String,dynamic>>deleteById(HttpRequest request, HttpResponse response) async {
    final params = request.params;
    final id = params['id'];
    Role? role = await _roleService.getById(int.tryParse(id)??0);
    if(role == null){
      throw AlfredException(HttpStatus.conflict, {'error': 'El role no existe'});
    }
    bool roleDelete= await _roleService.delete(role.id);
    return{
      'success': roleDelete,
      'role':role
    };
  }
}