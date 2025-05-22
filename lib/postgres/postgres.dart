import 'package:alfred/alfred.dart';
import 'package:postgres/postgres.dart';

import '../features/users/interfaces/update_request.dart';

class DatabaseService {
  late final Connection _connection;

  Future<void> connect() async {
    _connection = await Connection.open(
      Endpoint(
        host: '10.78.30.45',
        port: 5432,
        database: 'esequibo_nuestro',
        username: 'postgres',
        password: 'desarrollo',
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );
   // print('Conexión establecida con PostgreSQL');
  }

  Future<void> close() async {
    await _connection.close();
    //print('Conexión cerrada');
  }



  Future<void> _dropExistingTables() async {
    try {
      await _connection.execute('DROP TABLE IF EXISTS empleado CASCADE');
      await _connection.execute('DROP TABLE IF EXISTS direccion CASCADE');
      print('Tablas existentes eliminadas');
    } catch (e) {
      print('Error al eliminar tablas: $e');
      // Si hay error, probablemente las tablas no existían
    }
  }

  Future<void> initializeDatabase() async {
    await _dropExistingTables();
    await _connection.execute('''
      CREATE TABLE IF NOT EXISTS direccion (
        id SERIAL PRIMARY KEY,
        direccion VARCHAR(100) NOT NULL
      )
    ''');

    await _connection.execute('''
      CREATE TABLE IF NOT EXISTS empleado (
        id SERIAL PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        cedula INTEGER NOT NULL,
        direccion_id INTEGER NOT NULL,
        centro_votacion VARCHAR(200) NOT NULL,
        voto BOOLEAN DEFAULT FALSE,
        votostr VARCHAR(100) DEFAULT 'NO VOTO',
        FOREIGN KEY (direccion_id) REFERENCES direccion(id) ON DELETE CASCADE
      )
    ''');
    print('Tablas creadas/verificadas');
  }

  // CRUD para Direccion
  Future<int> createDireccion(String direccion) async {
    final result = await _connection.execute(
      Sql(r'INSERT INTO direccion (direccion) VALUES ($1) RETURNING id'),
      parameters: [direccion],
    );
    return result[0][0] as int;
  }

  // CRUD para Empleado
  Future<int> createEmpleado({
    required String nombre,
    required int cedula,
    required int direccionId,
    required String centroVotacion,
    bool voto = false,
    String votostr = 'NO VOTO',
  }) async {
    final result = await _connection.execute(
      Sql(r'''
        INSERT INTO empleado 
        (nombre, cedula, direccion_id, centro_votacion, voto, votostr) 
        VALUES ($1, $2, $3, $4, $5, $6) 
        RETURNING id
      '''),
      parameters: [
        nombre,
        cedula,
        direccionId,
        centroVotacion,
        voto,
        votostr,
      ],
    );
    return result[0][0] as int;
  }


  Future<List<Map<String, dynamic>>> getDireccion() async {
    try {
      final result = await _connection.execute(
        Sql('SELECT * FROM direccion ORDER BY id'),
      );

      return result.map((row) {
        final columnMap = row.toColumnMap();
        return {
          'id': columnMap['id'],
          'direccion': columnMap['direccion'],
        };
      }).toList();
    } catch (e) {
      print('Error en getDireccion: $e');
      return [];
    }
  }


  Future<List<Map<String, dynamic>>> getEmpleados() async {
    final result = await _connection.execute(
      Sql('''
      SELECT 
        e.id as empleado_id,
        e.nombre,
        e.cedula,
        e.direccion_id,
        e.centro_votacion,
        e.voto,
        e.votostr,
        d.id as direccion_id,
        d.direccion
      FROM empleado e
      JOIN direccion d ON e.direccion_id = d.id
    '''),
    );

    return result.map((row) {
      final columnMap = row.toColumnMap();
      return {
        'id': columnMap['empleado_id'],
        'nombre': columnMap['nombre'],
        'cedula': columnMap['cedula'],
        'direccion_id': columnMap['direccion_id'],
        'centro_votacion': columnMap['centro_votacion'],
        'voto': columnMap['voto'],
        'votostr': columnMap['votostr'],
        'direccion': {
          'id': columnMap['direccion_id'],
          'direccion': columnMap['direccion'],
        },
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getEmpleadosFilter({required bool voto}) async {
    final result = await _connection.execute(
      Sql(r'''
      SELECT 
        e.id as empleado_id,
        e.nombre,
        e.cedula,
        e.direccion_id,
        e.centro_votacion,
        e.voto,
        e.votostr,
        d.id as direccion_id,
        d.direccion
      FROM empleado e
      JOIN direccion d ON e.direccion_id = d.id
      WHERE e.voto =  $1   
    '''),
      parameters: [
        voto
      ],
    );

    return result.map((row) {
      final columnMap = row.toColumnMap();
      return {
        'id': columnMap['empleado_id'],
        'nombre': columnMap['nombre'],
        'cedula': columnMap['cedula'],
        'direccion_id': columnMap['direccion_id'],
        'centro_votacion': columnMap['centro_votacion'],
        'voto': columnMap['voto'],
        'votostr': columnMap['votostr'],
        'direccion': {
          'id': columnMap['direccion_id'],
          'direccion': columnMap['direccion'],
        },
      };
    }).toList();
  }


  Future<List<Map<String, dynamic>>> getEmpleadosDireccion({required String direccion}) async {
    final result = await _connection.execute(
      Sql(r'''
      SELECT 
        e.id as empleado_id,
        e.nombre,
        e.cedula,
        e.direccion_id,
        e.centro_votacion,
        e.voto,
        e.votostr,
        d.id as direccion_id,
        d.direccion
      FROM empleado e
      JOIN direccion d ON e.direccion_id = d.id
      WHERE d.direccion = $1  -- Aquí está el cambio: filtramos por nombre de dirección
    '''),
      parameters: [
        direccion, // El valor del filtro
      ],
    );

    return result.map((row) {
      final columnMap = row.toColumnMap();
      return {
        'id': columnMap['empleado_id'],
        'nombre': columnMap['nombre'],
        'cedula': columnMap['cedula'],
        'direccion_id': columnMap['direccion_id'],
        'centro_votacion': columnMap['centro_votacion'],
        'voto': columnMap['voto'],
        'votostr': columnMap['votostr'],
        'direccion': {
          'id': columnMap['direccion_id'],
          'direccion': columnMap['direccion'],
        },
      };
    }).toList();
  }


  Future<void> updateVotoStatus(int empleadoId, bool voto) async {
    await _connection.execute(
      Sql(r'UPDATE empleado SET voto = $1, votostr = $2 WHERE id = $3'),
      parameters: [
        voto,
        voto ? 'VOTÓ' : 'NO VOTO',
        empleadoId,
      ],
    );
  }

  Future<void> updateVotoStatusAll( bool voto) async {
    await _connection.execute(
      Sql(r'UPDATE empleado SET voto = $1, votostr = $2'),
      parameters: [
        voto,
        voto ? 'VOTÓ' : 'NO VOTO',
      ],
    );
  }


  Future<int> getCountByDireccion(String direccion) async {
    try {
      final result = await _connection.execute(
        Sql(r'''
        SELECT COUNT(e.id) as votantes
        FROM empleado e
        JOIN direccion d ON e.direccion_id = d.id
        WHERE e.voto = true AND d.direccion = $1
      '''),
        parameters: [direccion],
      );

      if (result.isEmpty || result[0].isEmpty) {
        print('No se encontraron resultados para la dirección: $direccion');
        return 0;
      }

      final count = result[0][0] as int;
     // print('Encontrados $count votantes para $direccion');
      return count;
    } catch (e) {
      print('Error en getCountByDireccion: $e');
      return 0;
    }
  }
}






void votacionRoute(String url,Alfred app){

  app.get('${url}empleado/count/:id',(req, res) async {
    final direccion = req.params['id'];
    final dbService = DatabaseService();
    try{
      await dbService.connect();

      final count = await dbService.getCountByDireccion(direccion);
      return{
        "nombre":direccion,
        "votos": count
      };

    }catch (e) {
      print('Error: $e');
    } finally {
      await dbService.close();
    }
  });




  app.get('${url}empleado/direccion',(req, res) async {
    final dbService = DatabaseService();
    try{
      await dbService.connect();
      final dir = await dbService.getDireccion();
      return{
        "direcciones": dir
      };

    }catch (e) {
      print('Error: $e');
    } finally {
      await dbService.close();
    }
  },);

  app.get('${url}empleado',(req, res) async {
    final dbService = DatabaseService();
    try{
      await dbService.connect();
      final empleados = await dbService.getEmpleados();
      return{
        "empleado": empleados
      };

    }catch (e) {
      print('Error: $e');
    } finally {
      await dbService.close();
    }
  });

  app.get('${url}empleado/filter',(req, res) async {
    final params = req.uri.queryParameters['status'];
    final dbService = DatabaseService();
    try{
      await dbService.connect();
      late final empleados;
      print(params);
      if(params=="all"){
         empleados = await dbService.getEmpleados();
      }else if(params=='no'){
         empleados = await dbService.getEmpleadosFilter(voto: false);
      }else if(params=='si'){
         empleados = await dbService.getEmpleadosFilter(voto: true);
      }else{
        empleados = await dbService.getEmpleadosDireccion(direccion: params!);
      }
      return{
        "empleado": empleados
      };

    }catch (e) {
      print('Error: $e');
    } finally {
      await dbService.close();
    }
  });

  app.patch('${url}empleado/:id',(req, res) async {
    final body = await req.bodyAsJsonMap;
    final dynamicRequest = DynamicRequest(body);
    final id = req.params['id'];
    final dbService = DatabaseService();
      try{
        await dbService.connect();

        print(id);
        final voto=dynamicRequest.call("voto");
        final votostr=dynamicRequest.call("votostr");
        print("${voto} - ${votostr}");
        await dbService.updateVotoStatus(int.tryParse(id)!,voto);//updateVotoStatus(int.tryParse(id),voto);

        return{
          "susses":true
        };
      }catch (e) {
        print('Error: $e');
      } finally {
         await dbService.close();
      }
  });
  app.patch('${url}empleado-all/',(req, res) async {
    final body = await req.bodyAsJsonMap;
    final dynamicRequest = DynamicRequest(body);

    final dbService = DatabaseService();
    try{
      await dbService.connect();
      final voto=dynamicRequest.call("voto");

      print(" voto: ${voto} ");
      await dbService.updateVotoStatusAll(voto);

      return{
        "susses":true
      };
    }catch (e) {
      print('Error: $e');
    } finally {
      await dbService.close();
    }
  });
}



final List<String> departments = [
  'Dirección General de Administración',
  'Dirección General de Egreso',
  'Dirección General de Ingreso',
  'Dirección General de Cuenta Única',
  'Dirección General de Tecnología Información',
  'Dirección General de Planificación y Análisis Financiero',
  'Dirección General de Recursos Humanos',
  'Dirección General de Inversiones y Valores',
  'Dirección General de Consultoría Jurídica',
];

final List<Map<String, dynamic>> empleadosEjemplo = [
  {
    'nombre': 'Ana Fernández',
    'cedula': 87654321,
    'centroVotacion': 'Escuela Nacional',
    'voto': false,
    'votostr': 'NO VOTO', // Coincide con voto: false
  },
  {
    'nombre': 'Carlos Rodríguez',
    'cedula': 12345678,
    'centroVotacion': 'Liceo Bolivariano',
    'voto': true,
    'votostr': 'VOTÓ', // Coincide con voto: true
  },
  {
    'nombre': 'María González',
    'cedula': 11223344,
    'centroVotacion': 'Colegio Santa María',
    'voto': false,
    'votostr': 'NO VOTO', // Coincide con voto: false
  },
  {
    'nombre': 'José Pérez',
    'cedula': 55667788,
    'centroVotacion': 'Unidad Educativa Distrital',
    'voto': true,
    'votostr': 'VOTÓ', // Coincide con voto: true
  },
  {
    'nombre': 'Luisa Martínez',
    'cedula': 99887766,
    'centroVotacion': 'Instituto Técnico',
    'voto': false,
    'votostr': 'NO VOTO', // Coincide con voto: false
  },
  // Puedes agregar más empleados manteniendo la misma estructura
];



Future<void> postgres() async {
  final dbService = DatabaseService();

  try {


    await dbService.connect();
    await dbService.initializeDatabase();

    /*
    final direccionesIds = <int>[];
    for (final depto in departments) {
      final id = await dbService.createDireccion(depto);
      direccionesIds.add(id);
      print('✅ Departamento creado: $depto (ID: $id)');
    }

    // Crear empleados para cada departamento
    for (var i = 0; i < direccionesIds.length; i++) {
      final direccionId = direccionesIds[i];
      final deptoNombre = departments[i];

      for (final empleado in empleadosEjemplo) {
        final empleadoId = await dbService.createEmpleado(
          nombre: empleado['nombre'],
          cedula: empleado['cedula'],
          direccionId: direccionId,
          centroVotacion: empleado['centroVotacion'],
          votostr: empleado['votostr'],
          voto: empleado['voto']
        );
        print('👤 Empleado ${empleado['nombre']} creado en $deptoNombre (ID: $empleadoId)');
      }
    }

    print('✅ Todos los empleados fueron creados exitosamente!');
    for(final d in departments){
      var count = await   dbService.getCountByDireccion(d);
      print(count);
    }

     */



    /*// Ejemplo de uso
    final direccionId = await dbService.createDireccion('DIRECCION DE TECNOLOGIA');
    print('Dirección creada con ID: $direccionId');


    final empleadoId = await dbService.createEmpleado(
      nombre: 'Ana Fernández',
      cedula: 87654321,
      direccionId: direccionId,
      centroVotacion: 'Escuela Nacional',
        votostr:"no voto"
    );

    print('Empleado creado con ID: $empleadoId');

    // Actualizar estado de voto
    await dbService.updateVotoStatus(empleadoId, true);
    print('Estado de voto actualizado');

    // Listar todos los empleados
    final empleados = await dbService.getEmpleados();
    print('\nListado de empleados:');
    for (final emp in empleados) {
      print('${emp['nombre']} - ${emp['cedula']} - ${emp['direccion']['direccion']} - ${emp['centro_votacion']} - ${emp['voto']} - ${emp['votostr']}');
    }*/

  } catch (e) {
    print('Error: $e');
  } finally {
    await dbService.close();
  }
}