

import 'package:alfred/alfred.dart';

import '../../../shared/app_strings.dart';

class RegisterRequest {
  final String email;
  final String password;
  final String name;
  final String department;
  final String role;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.department,
    this.role = AppStrings.user, // Valor predeterminado para el rol
  });

  /// Método estático para crear una instancia desde un Map<String, dynamic>
  static RegisterRequest fromJson(Map<String, dynamic> json) {
    final email = json['email'] as String?;
    final password = json['password'] as String?;
    final name = json['name'] as String?;
    final department = json['department'] as String?;
    final role = json['role'] as String?;
   // final position = json['position'] as String?;

    if (email == null || password == null || name == null || department == null) {
      throw AlfredException(400, {'error': 'Todos los campos son requeridos: email, password, name, department'});
    }

    return RegisterRequest(
      email: email,
      password: password,
      name: name,
      department: department,
      role: role ?? AppStrings.user,
    );
  }

  void show(){
    print("$email - $password - $name - $department - $role");
  }
}
