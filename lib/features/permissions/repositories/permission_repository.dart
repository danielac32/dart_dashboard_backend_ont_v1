

import '../../../model/model.dart';
import '../../../objectbox.g.dart';


class PermissionRepository {
  final Store store;
  late final Box<Permission> _permissionBox;

  PermissionRepository(this.store) {
    _permissionBox = store.box<Permission>();
  }

  int create(Permission permission) => _permissionBox.put(permission);

  bool delete(int permissionId) => _permissionBox.remove(permissionId);

  List<Permission> getByUser(int userId) {
    final query = _permissionBox.query(Permission_.user.equals(userId)).build();
    final permissions = query.find();
    query.close();
    return permissions;
  }

  List<String> getSectionsByUser(int userId) {
    final permissions = getByUser(userId);
    return permissions.map((p) => p.section).toSet().toList();
  }
}