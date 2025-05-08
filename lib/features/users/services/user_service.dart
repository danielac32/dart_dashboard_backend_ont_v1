
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

