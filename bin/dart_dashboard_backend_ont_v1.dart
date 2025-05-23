import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dart_dashboard_backend_ont_v1/config/init.dart';

/*
// router.dart
class User {
  final int id;
  late final String name;
  late final String email;

  User({required this.id, required this.name, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

//
class UserRepository {
  final List<User> _users = [];

  List<User> getAll() {
    return [..._users];
  }

  User? getById(int id) {
    return _users.firstWhere((user) => user.id == id,/* orElse: () => null*/);
  }

  User create(String name, String email) {
    final newUser = User(id: _users.length + 1, name: name, email: email);
    _users.add(newUser);
    return newUser;
  }

  User update(int id, String name, String email) {
    final user = getById(id);
    if (user == null) {
      throw Exception('User not found');
    }
    user.name = name;
    user.email = email;
    return user;
  }

  void delete(int id) {
    final index = _users.indexWhere((user) => user.id == id);
    if (index == -1) {
      throw Exception('User not found');
    }
    _users.removeAt(index);
  }
}


class Router {
  final Map<String, Function(HttpRequest)> routes = {};

  void addRoute(String method, String path, Function(HttpRequest) handler) {
    final key = '$method $path';
    routes[key] = handler;
  }

  void handleRequest(HttpRequest request) {
    final method = request.method;
    final path = request.requestedUri.path;
    final key = '$method $path';

    final handler = routes[key];

    if (handler != null) {
      handler(request);
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write('Not Found');
      request.response.close();
    }
  }
}

class UserController {
  final UserRepository _repository = UserRepository();

  List<User> getAllUsers() {
    return _repository.getAll();
  }

  User getUserById(int id) {
    return _repository.getById(id)!;
  }

  User createUser(String name, String email) {
    return _repository.create(name, email);
  }

  User updateUser(int id, String name, String email) {
    return _repository.update(id, name, email);
  }

  void deleteUser(int id) {
    _repository.delete(id);
  }
}

 */





Future<void> main(List<String> arguments) async {

/*
  final router = Router();
  final controller = UserController();

  // Rutas CRUD
  router.addRoute('GET', '/users', (HttpRequest request) {
    final users = controller.getAllUsers();
    final response = jsonEncode(users.map((user) => user.toJson()).toList());
    request.response.write(response);
    request.response.close();
  });

  router.addRoute('GET', '/users/{id}', (HttpRequest request) {
    final id = int.parse(Uri.parse(request.requestedUri.path).pathSegments.last);
    final user = controller.getUserById(id);
    final response = jsonEncode(user.toJson());
    request.response.write(response);
  });

  router.addRoute('POST', '/users', (HttpRequest request) async {
    final body = await utf8.decoder.bind(request).join();
    final data = jsonDecode(body);
    final user = controller.createUser(data['name'], data['email']);
    final response = jsonEncode(user.toJson());
    request.response.write(response);
    request.response.close();
  });

  router.addRoute('PUT', '/users/{id}', (HttpRequest request) async {
    final id = int.parse(Uri.parse(request.requestedUri.path).pathSegments.last);
    final body = await utf8.decoder.bind(request).join();
    final data = jsonDecode(body);
    final user = controller.updateUser(id, data['name'], data['email']);
    final response = jsonEncode(user.toJson());
    request.response.write(response);
    request.response.close();
  });

  router.addRoute('DELETE', '/users/{id}', (HttpRequest request) {
    final id = int.parse(Uri.parse(request.requestedUri.path).pathSegments.last);
    controller.deleteUser(id);
    request.response.write('User deleted');
    request.response.close();
  });

  // Iniciar servidor
  HttpServer.bind('localhost', 3000).then((server) {
    print('Servidor corriendo en http://localhost:3000');
    server.listen((request) {
      router.handleRequest(request);
    });
  });
*/


  //return;
  // Verificar si no se proporcionaron argumentos

  if (arguments.isEmpty) {
    print('No se proporcionaron argumentos. Usa --help para más información.');
    return;
  }

  // Mapa para almacenar los flags y sus valores
  final Map<String, String?> flags = {};

  // Procesar los argumentos
  for (final arg in arguments) {
    // Dividir el argumento en flag y valor (si existe)
    if (arg.startsWith('--')) {
      final parts = arg.substring(2).split('=');
      final flag = parts[0];
      final value = parts.length > 1 ? parts[1] : null;

      // Almacenar el flag y su valor en el mapa
      flags[flag] = value;
    } else {
      print('Argumento inválido: $arg. Los argumentos deben comenzar con "--".');
      return;
    }
  }

  // Evaluar los flags y sus valores
  if (flags.containsKey('help')) {
    print('Uso: dart run <comando> [opciones]');
    print('Opciones disponibles:');
    print('  --env=<environment>   Especifica el entorno (development, production).');
    print('  --port=<port>         Especifica el puerto del servidor.');
    print('  --seed                Ejecuta el proceso de seeding (inserción de datos iniciales).');
    print('  --reset-db            Elimina el directorio objectbox-db.');
    print('  --help                Muestra esta ayuda.');
    return;
  }

  // Flag --reset-db: Eliminar el directorio objectbox-db
  if (flags.containsKey('reset-db')) {
    final dbPath = 'objectbox-db';
    try {
      if (Directory(dbPath).existsSync()) {
        Directory(dbPath).deleteSync(recursive: true);
        print('Directorio "$dbPath" eliminado correctamente.');
      } else {
        print('El directorio "$dbPath" no existe.');
      }
    } catch (e) {
      print('Error al eliminar el directorio "$dbPath": $e');
    }
    return; // Terminar después de eliminar la base de datos
  }


  bool seed=false;
  // Flag --seed: Ejecutar el proceso de seeding
  if (flags.containsKey('seed')) {
    try {
      seedDatabase(); // Función para insertar datos iniciales
      //print('Proceso de seeding completado exitosamente.');
      seed=true;
    } catch (e) {
      print('Error durante el proceso de seeding: $e');
    }
  }


  if (flags.containsKey('oracle')) {
    try {

    } catch (e) {
      print('Error durante el proceso de seeding: $e');
    }
    return;
  }


  // Obtener el entorno
  final env = flags['env'] ?? 'development'; // Por defecto, usa "development"


  // Obtener el puerto
  final portString = flags['port'];
  if (portString != null) {
    final port = int.tryParse(portString);
    if (port == null) {
      print('Error: El valor del puerto debe ser un número válido.');
      return;
    }
    //print('Puerto: $port');
  } else {
    print('Puerto no especificado. Usando puerto predeterminado: 8080');
  }

  // Inicializar el sistema con los parámetros obtenidos
  init_System(env: env, port: portString != null ? int.parse(portString) : 8080,seed: seed);
}

// Función para simular el proceso de seeding
void seedDatabase() {
  // Aquí puedes implementar la lógica para insertar datos iniciales en la base de datos
  print('Insertando datos iniciales en la base de datos...');
}




