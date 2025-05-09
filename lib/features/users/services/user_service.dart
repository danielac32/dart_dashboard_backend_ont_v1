
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
    );
    return _userRepository.create(user);
  }
}

