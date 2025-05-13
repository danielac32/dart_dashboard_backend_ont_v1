
import 'package:objectbox/objectbox.dart';

import '../../../model/model.dart';
import '../../../objectbox.g.dart';


class UserRepository {
  final Store store;
  late final Box<User> _userBox;

  UserRepository(this.store) {
    _userBox = store.box<User>();
  }
  List<User> getAll() => _userBox.getAll();

  int create(User user) => _userBox.put(user);

  bool update(User user) => _userBox.put(user,mode: PutMode.update) > 0;

  bool delete(int userId) => _userBox.remove(userId);

  User? getById(int id) => _userBox.get(id);

  User? getByEmail(String email) {
   /* if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return null;
    }*/
    final query = _userBox.query(User_.email.equals(email)).build();
    final user = query.findFirst();
    query.close();
    return user;
  }


  List<User> getByActive(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        final qActive = _userBox.query(User_.isActive.equals(true)).build();
        final users = qActive.find();
        qActive.close();
        return users;

      case 'inactive':
        final qInactive = _userBox.query(User_.isActive.equals(false)).build();
        final users = qInactive.find();
        qInactive.close();
        return users;

      case 'all':
        return _userBox.getAll();

      default:
        throw Exception("Status inválido. Usa 'active', 'inactive' o 'all'");
    }
  }


  List<User> getByRole(String role) {
    final query = _userBox.query(User_.role.equals(role)).build();
    final users = query.find();
    query.close();
    return users;
  }

  List<User> getByDepartment(String department) {
    final query = _userBox.query(User_.department.equals(department)).build();
    final users = query.find();
    query.close();
    return users;
  }

  List<Permission> getPermissionsByUser(int userId) {
    final user = _userBox.get(userId);
    return user?.permissions.toList() ?? [];
  }

  bool addPermissionToUser(int userId, Permission permission) {
    final user = _userBox.get(userId);
    if (user != null) {
      user.permissions.add(permission);
      _userBox.put(user);
      return true;
    }
    return false;
  }

  bool removePermissionFromUser(int userId, int permissionId) {
    final user = _userBox.get(userId);
    if (user != null) {
      final permission = store.box<Permission>().get(permissionId);
      if (permission != null) {
        user.permissions.remove(permission);
        _userBox.put(user);
        return true;
      }
    }
    return false;
  }

  List<OrganismoGobernacion> getOrganismosByUser(int userId) {
    final user = _userBox.get(userId);
    return user?.organismosGobernacion.toList() ?? [];
  }

  bool addOrganismoToUser(int userId, OrganismoGobernacion organismo) {
    final user = _userBox.get(userId);
    if (user != null) {
      user.organismosGobernacion.add(organismo);
      _userBox.put(user);
      return true;
    }
    return false;
  }

  bool removeOrganismoFromUser(int userId, int organismoId) {
    final user = _userBox.get(userId);
    if (user != null) {
      final organismo = store.box<OrganismoGobernacion>().get(organismoId);
      if (organismo != null) {
        user.organismosGobernacion.remove(organismo);
        _userBox.put(user);
        return true;
      }
    }
    return false;
  }

  List<ProgramacionFinanciera> getProgramacionesByUser(int userId) {
    final user = _userBox.get(userId);
    return user?.programacionesFinancieras.toList() ?? [];
  }

  bool addProgramacionToUser(int userId, ProgramacionFinanciera programacion) {
    final user = _userBox.get(userId);
    if (user != null) {
      user.programacionesFinancieras.add(programacion);
      _userBox.put(user);
      return true;
    }
    return false;
  }

  bool removeProgramacionFromUser(int userId, int programacionId) {
    final user = _userBox.get(userId);
    if (user != null) {
      final programacion = store.box<ProgramacionFinanciera>().get(programacionId);
      if (programacion != null) {
        user.programacionesFinancieras.remove(programacion);
        _userBox.put(user);
        return true;
      }
    }
    return false;
  }

  List<ResumenGestion> getResumenesByUser(int userId) {
    final user = _userBox.get(userId);
    return user?.resumenesGestion.toList() ?? [];
  }

  bool addResumenToUser(int userId, ResumenGestion resumen) {
    final user = _userBox.get(userId);
    if (user != null) {
      user.resumenesGestion.add(resumen);
      _userBox.put(user);
      return true;
    }
    return false;
  }

  bool removeResumenFromUser(int userId, int resumenId) {
    final user = _userBox.get(userId);
    if (user != null) {
      final resumen = store.box<ResumenGestion>().get(resumenId);
      if (resumen != null) {
        user.resumenesGestion.remove(resumen);
        _userBox.put(user);
        return true;
      }
    }
    return false;
  }

  List<Noticia> getNoticiasByUser(int userId) {
    final user = _userBox.get(userId);
    return user?.noticias.toList() ?? [];
  }

  bool addNoticiaToUser(int userId, Noticia noticia) {
    final user = _userBox.get(userId);
    if (user != null) {
      user.noticias.add(noticia);
      _userBox.put(user);
      return true;
    }
    return false;
  }

  bool removeNoticiaFromUser(int userId, int noticiaId) {
    final user = _userBox.get(userId);
    if (user != null) {
      final noticia = store.box<Noticia>().get(noticiaId);
      if (noticia != null) {
        user.noticias.remove(noticia);
        _userBox.put(user);
        return true;
      }
    }
    return false;
  }



}