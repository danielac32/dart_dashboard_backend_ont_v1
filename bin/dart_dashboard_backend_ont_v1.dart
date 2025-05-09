import 'dart:io';
import 'package:dart_dashboard_backend_ont_v1/config/init.dart';

Future<void> main(List<String> arguments) async {
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




