


import '../repositories/permission_repository.dart';
import '../../../model/model.dart';



class PermissionService{
  final PermissionRepository _permissionRepository;
  PermissionService(this._permissionRepository);

  int create(Permission permission) => _permissionRepository.create(permission);


  bool update(Permission permission) => _permissionRepository.update(permission);

  bool delete(int permissionId) => _permissionRepository.delete(permissionId);

  Permission? getPermissionsById(int id){
    return _permissionRepository.getPermissionsById(id);
  }

  Permission? getPermissionByUserAndSection(int userId, String section){
    return _permissionRepository.getPermissionByUserAndSection(userId, section);
  }
  List<Permission> getByUser(int userId) {
    return _permissionRepository.getByUser(userId);
  }

  List<String> getSectionsByUser(int userId) {
    return _permissionRepository.getSectionsByUser(userId);
  }

}