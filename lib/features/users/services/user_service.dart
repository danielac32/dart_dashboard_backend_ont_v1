
import 'package:dart_dashboard_backend_ont_v1/features/users/repositories/user_repository.dart';
import 'package:dart_dashboard_backend_ont_v1/shared/app_strings.dart';
import '../../../model/model.dart';

class UserService {
  final UserRepository _userRepository;
  UserService(this._userRepository);

  Future<List<User>> getUsersByFilter({String? role, String? department}) async {
    if (role != null) return _userRepository.getByRole(role);
    if (department != null) return _userRepository.getByDepartment(department);
    return _userRepository.getAll();
  }


  bool update(User userUpdate){
    final user=_userRepository.update(userUpdate);
    return user;
  }
  bool delete(int userId){
    return _userRepository.delete(userId);
  }


  Future<User?> getByIdEmail(String id) async {
    // Intentar obtener el usuario por email
    var user = _userRepository.getByEmail(id);
    // Si no se encontró el usuario por email, intentar obtenerlo por ID
    if (user == null) {
      final parsedId = int.tryParse(id); // Intentar convertir el ID a un número
      if (parsedId != null) {
        user = _userRepository.getById(parsedId); // Buscar por ID si es válido
      }
    }
    return user;
  }


  Future <User?> getById(int id) async{
    final user = _userRepository.getById(id);
    return user;
  }
  Future <User?> getByEmail(String email) async{
    final user = _userRepository.getByEmail(email);
    return user;
  }

  Future<User?> login( String email,  String password) async {
    final user = _userRepository.getByEmail(email);
    return user != null && user.password == password ? user : null;
  }

  Future<int> register({
    required String email,
    required String password,
    required String name,
    required String department,
    String role = AppStrings.user,
    required String position,
  }) async {
    if (_userRepository.getByEmail(email) != null) {
      throw Exception('El usuario con este email ya existe');
    }
    final user = User(
      email: email,
      password: password,
      name: name,
      department: department,
      role: role,
      position: position
    );
    return _userRepository.create(user);
  }

  // Métodos para manejar las relaciones ToMany

  List<Permission> getPermissionsByUser(int userId) {
    try {
      return _userRepository.getPermissionsByUser(userId);
    } catch (e) {
      throw Exception('Error al obtener los permisos del usuario: $e');
    }
  }

  bool addPermissionToUser(int userId, Permission permission) {
    try {
      return _userRepository.addPermissionToUser(userId, permission);
    } catch (e) {
      throw Exception('Error al agregar el permiso al usuario: $e');
    }
  }

  bool removePermissionFromUser(int userId, int permissionId) {
    try {
      return _userRepository.removePermissionFromUser(userId, permissionId);
    } catch (e) {
      throw Exception('Error al eliminar el permiso del usuario: $e');
    }
  }

  List<OrganismoGobernacion> getOrganismosByUser(int userId) {
    try {
      return _userRepository.getOrganismosByUser(userId);
    } catch (e) {
      throw Exception('Error al obtener los organismos del usuario: $e');
    }
  }

  bool addOrganismoToUser(int userId, OrganismoGobernacion organismo) {
    try {
      return _userRepository.addOrganismoToUser(userId, organismo);
    } catch (e) {
      throw Exception('Error al agregar el organismo al usuario: $e');
    }
  }

  bool removeOrganismoFromUser(int userId, int organismoId) {
    try {
      return _userRepository.removeOrganismoFromUser(userId, organismoId);
    } catch (e) {
      throw Exception('Error al eliminar el organismo del usuario: $e');
    }
  }

  List<ProgramacionFinanciera> getProgramacionesByUser(int userId) {
    try {
      return _userRepository.getProgramacionesByUser(userId);
    } catch (e) {
      throw Exception('Error al obtener las programaciones del usuario: $e');
    }
  }

  bool addProgramacionToUser(int userId, ProgramacionFinanciera programacion) {
    try {
      return _userRepository.addProgramacionToUser(userId, programacion);
    } catch (e) {
      throw Exception('Error al agregar la programación al usuario: $e');
    }
  }

  bool removeProgramacionFromUser(int userId, int programacionId) {
    try {
      return _userRepository.removeProgramacionFromUser(userId, programacionId);
    } catch (e) {
      throw Exception('Error al eliminar la programación del usuario: $e');
    }
  }

  List<ResumenGestion> getResumenesByUser(int userId) {
    try {
      return _userRepository.getResumenesByUser(userId);
    } catch (e) {
      throw Exception('Error al obtener los resúmenes del usuario: $e');
    }
  }

  bool addResumenToUser(int userId, ResumenGestion resumen) {
    try {
      return _userRepository.addResumenToUser(userId, resumen);
    } catch (e) {
      throw Exception('Error al agregar el resumen al usuario: $e');
    }
  }

  bool removeResumenFromUser(int userId, int resumenId) {
    try {
      return _userRepository.removeResumenFromUser(userId, resumenId);
    } catch (e) {
      throw Exception('Error al eliminar el resumen del usuario: $e');
    }
  }

  List<Noticia> getNoticiasByUser(int userId) {
    try {
      return _userRepository.getNoticiasByUser(userId);
    } catch (e) {
      throw Exception('Error al obtener las noticias del usuario: $e');
    }
  }

  bool addNoticiaToUser(int userId, Noticia noticia) {
    try {
      return _userRepository.addNoticiaToUser(userId, noticia);
    } catch (e) {
      throw Exception('Error al agregar la noticia al usuario: $e');
    }
  }

  bool removeNoticiaFromUser(int userId, int noticiaId) {
    try {
      return _userRepository.removeNoticiaFromUser(userId, noticiaId);
    } catch (e) {
      throw Exception('Error al eliminar la noticia del usuario: $e');
    }
  }


}

