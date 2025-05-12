


import '../../../model/model.dart';
import '../../../objectbox.g.dart';

class DireccionRepository{
  final Store store;
  late final Box<Direccion> _direccionBox;

  DireccionRepository(this.store) {
    _direccionBox = store.box<Direccion>();
  }
  List<Direccion> getAll() => _direccionBox.getAll();

  int create(Direccion dir) => _direccionBox.put(dir);

  bool update(Direccion dir) => _direccionBox.put(dir,mode: PutMode.update) > 0;

  bool delete(int dirId) => _direccionBox.remove(dirId);

  Direccion? getById(int id) => _direccionBox.get(id);

  bool getByName(String name){
    final direccion = _direccionBox.query(Direccion_.name.equals(name)).build().findFirst();
    if (direccion != null) {
        return true;//print("Dirección encontrada: ${direcciones.first.name}");
    } else {
      return false;//print("No se encontró la Dirección con ese name");
    }
  }

  /***********************************************************************/
}

class CargoRepository{
  final Store store;
  late final Box<Cargo> _cargoBox;

  CargoRepository(this.store) {
    _cargoBox = store.box<Cargo>();
  }
  List<Cargo> getAll() => _cargoBox.getAll();

  int create(Cargo cargo) => _cargoBox.put(cargo);

  bool update(Cargo cargo) => _cargoBox.put(cargo,mode: PutMode.update) > 0;

  bool delete(int cargoId) => _cargoBox.remove(cargoId);

  Cargo? getById(int id) => _cargoBox.get(id);

  bool getByName(String name){
    final cargo = _cargoBox.query(Cargo_.name.equals(name)).build().findFirst();
    if (cargo != null) {
      return true;//print("Dirección encontrada: ${direcciones.first.name}");
    } else {
      return false;//print("No se encontró la Dirección con ese name");
    }
  }
/***********************************************************************/
}

class RoleRepository{
  final Store store;
  late final Box<Role> _roleBox;

  RoleRepository(this.store) {
     _roleBox = store.box<Role>();
  }
  List<Role> getAll() => _roleBox.getAll();

  int create(Role role) => _roleBox.put(role);

  bool update(Role role) => _roleBox.put(role,mode: PutMode.update) > 0;

  bool delete(int roleId) => _roleBox.remove(roleId);

  Role? getById(int id) => _roleBox.get(id);

  bool getByName(String name){
    final role = _roleBox.query(Role_.name.equals(name)).build().findFirst();
    if (role != null) {
      return true;//print("Dirección encontrada: ${direcciones.first.name}");
    } else {
      return false;//print("No se encontró la Dirección con ese name");
    }
  }
/***********************************************************************/
}