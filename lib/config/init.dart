

import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:dart_dashboard_backend_ont_v1/config/seeder.dart';
import 'package:dart_dashboard_backend_ont_v1/features/users/services/user_service.dart';
import 'package:dart_dashboard_backend_ont_v1/utils/DireccionCargoRole/services/dcr_services.dart';

import 'package:objectbox/objectbox.dart';
import '../features/users/repositories/user_repository.dart';
import '../features/users/routes/routes.dart';
import '../objectbox.g.dart';
import '../utils/DireccionCargoRole/repository/dcr_repository.dart';
import '../utils/DireccionCargoRole/routes/dcr_routes.dart';


class AppApi{
  final int port;
  final Alfred app = Alfred();
  final Store store;

  AppApi({this.port=8080, required this.store});

  Future<void> start()async {
    app.all('*', cors(origin: '*'));

    final userRepo=UserRepository(store);
    final direccionRepository=DireccionRepository(store);
    final cargoRepository=CargoRepository(store);
    final roleRepository=RoleRepository(store);

    final direccionService=DireccionService(direccionRepository);
    final cargoService=CargoService(cargoRepository);
    final roleService=RoleService(roleRepository);

    final userService=UserService(userRepo);
    authRoutes('auth/',app,userService);
    userRoutes('user/',app,userService);

    direccionRoutes('direccion/',app,direccionService);
    cargoRoutes('cargo/',app,cargoService);
    rolRoutes('role/',app,roleService);
    //globalRoutes(app);

    app.all('*', (req, res)  async {
      res.statusCode = 404;
      res.headers.contentType = ContentType.html;
        final file = File('public/404.html');
        if (await file.exists()) {
          return file.openRead();
        }
    });

    app.all('*', (req, res) {
      res.headers.add('Access-Control-Allow-Origin', '*');
    });

    await app.listen(port);
    print('Servidor escuchando en http://localhost:$port');
  }
}

Future<void> init_System({String env = 'development', int port = 8080,required bool seed}) async {
  print('Iniciando sistema en modo: $env');
  print('Usando puerto: $port');

  // Inicializar ObjectBox Store
  final store = Store(
    getObjectBoxModel(),
    directory: 'objectbox-db', // Directorio para almacenar la base de datos
  );
  if(seed){
    final seeder = DatabaseSeeder(store);
    await seeder.seed();
    return;
  }
  // Inicializar la API con el puerto especificado
  final api = AppApi(port: port, store: store);

  // Configurar comportamientos específicos según el entorno
  /*if (env == 'production') {
    print('Modo de producción activado.');
    // Aquí puedes agregar configuraciones específicas para producción
  } else if (env == 'development') {
    print('Modo de desarrollo activado.');
    // Aquí puedes agregar configuraciones específicas para desarrollo
  }*/

  // Iniciar la API
  api.start();
}