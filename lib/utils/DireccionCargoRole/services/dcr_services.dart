


import 'package:dart_dashboard_backend_ont_v1/model/model.dart';

import '../repository/dcr_repository.dart';

class DireccionService{
  final DireccionRepository _direccionRepository;
  DireccionService(this._direccionRepository);

  Future<List<Direccion>> get() async {
    return _direccionRepository.getAll();
  }
  Future<int>create(Direccion dir) async {
    return _direccionRepository.create(dir);
  }
  Future<bool> update(Direccion dir) async{
    return _direccionRepository.update(dir);
  }
  Future<Direccion?> getById(int dirId)async{
    return _direccionRepository.getById(dirId);
  }
  Future<bool> delete(int id) async{
    return _direccionRepository.delete(id);
  }
  Future<bool> exist(String name)async{
    return _direccionRepository.getByName(name);
  }
}

class CargoService{
  final CargoRepository _cargoRepository;
  CargoService(this._cargoRepository);

  Future<List<Cargo>> get() async {
    return _cargoRepository.getAll();
  }
  Future<int>create(Cargo cargo) async {
    return _cargoRepository.create(cargo);
  }
  Future<bool> update(Cargo cargo) async{
    return _cargoRepository.update(cargo);
  }
  Future<Cargo?> getById(int cargoId)async{
    return _cargoRepository.getById(cargoId);
  }
  Future<bool> delete(int id) async{
    return _cargoRepository.delete(id);
  }
  Future<bool> exist(String name)async{
    return _cargoRepository.getByName(name);
  }
}

class RoleService{
  final RoleRepository _roleRepository;
  RoleService(this._roleRepository);

  Future<List<Role>> get() async {
    return _roleRepository.getAll();
  }
  Future<int>create(Role role) async {
    return _roleRepository.create(role);
  }
  Future<bool> update(Role role) async{
    return _roleRepository.update(role);
  }
  Future<Role?> getById(int roleId)async{
    return _roleRepository.getById(roleId);
  }
  Future<bool> delete(int id) async{
    return _roleRepository.delete(id);
  }
  Future<bool> exist(String name)async{
    return _roleRepository.getByName(name);
  }
}