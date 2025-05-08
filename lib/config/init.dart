

import 'package:alfred/alfred.dart';
import 'package:dart_dashboard_backend_ont_v1/features/users/services/user_service.dart';
import 'package:dart_dashboard_backend_ont_v1/routes/routes.dart';
import 'package:objectbox/objectbox.dart';
import '../features/users/repositories/user_repository.dart';
import '../features/users/routes/routes.dart';
import '../objectbox.g.dart';


class AppApi{
  final int port;
  final Alfred app = Alfred();
  final Store store;

  AppApi({this.port=8080, required this.store});

  Future<void> start()async {
    //app.all('*', cors(origin: 'myorigin.com'));
    final userRepo=UserRepository(store);
    final userService=UserService(userRepo);
    authRoutes('auth/',app,userService);
    userRoutes('user/',app,userService);
    //globalRoutes(app);
    await app.listen(port);
    print('Servidor escuchando en http://localhost:$port');
  }
}


void init_System(){
  final store = Store(
    getObjectBoxModel(),
    directory: 'objectbox-db', // Directorio para almacenar la base de datos
  );

  final api = AppApi(port: 8080,store: store);
  api.start();
}