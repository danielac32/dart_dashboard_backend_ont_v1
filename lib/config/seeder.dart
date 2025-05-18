import 'package:objectbox/objectbox.dart';

import '../model/model.dart';
import '../shared/app_strings.dart';


class DatabaseSeeder {
  final Store store;

  DatabaseSeeder(this.store);

  Future<void> seed() async {
    final userBox = store.box<User>();
    final permissionBox = store.box<Permission>();
    final organismoBox = store.box<OrganismoGobernacion>();
    final alcaldiaBox = store.box<Alcaldia>();
    final programacionBox = store.box<ProgramacionFinanciera>();
    final mesBox = store.box<Mes>();
    final resumenBox = store.box<ResumenGestion>();
    final noticiaBox = store.box<Noticia>();

    final roleBox = store.box<Role>();
    final cargoBox = store.box<Cargo>();
    final direccionBox = store.box<Direccion>();


    roleBox.removeAll();
    cargoBox.removeAll();
    direccionBox.removeAll();
    // Limpiar datos existentes (opcional)
    userBox.removeAll();
    permissionBox.removeAll();
    organismoBox.removeAll();
    alcaldiaBox.removeAll();
    programacionBox.removeAll();
    mesBox.removeAll();
    resumenBox.removeAll();
    noticiaBox.removeAll();
/**********************************************************/
    final List<String> names = [
      "Juan Perez",
      "Maria Lopez",
      "Carlos Ramirez",
      "Ana Gomez",
      "Luis Martinez",
      "Laura Hernandez",
      "Pedro Sanchez",
      "Sofia Torres",
      "Diego Flores",
      "Camila Rios",
      "Javier Mendoza",
      "Valeria Castro",
      "Fernando Silva",
      "Isabella Morales",
      "Ricardo Guzman",
      "Daniela Vargas",
      "Miguel Navarro",
      "Gabriela Ortega",
      "Andres Paredes",
      "Carolina Jimenez",
      "Alejandro Ruiz",
      "Natalia Rojas",
      "Oscar Acosta",
      "Paula Vega",
      "Victor Soto",
      "Lucia Mora",
      "Manuel Espinoza",
      "Carmen Alvarado",
      "Roberto Medina",
      "Elena Chavez",
      "Sebastian Ponce",
      "Monica Salgado",
      "Hugo Nunez",
      "Adriana Aguilar",
      "Julio Contreras",
      "Veronica Molina",
      "Raul Peña",
      "Patricia Leon",
      "Ernesto Bravo",
      "Martha Campos",
      "Alberto Zuniga",
      "Beatriz Pacheco",
      "Felipe Rosales",
      "Gloria Villanueva",
      "Rodrigo Galindo",
      "Irene Calderon",
      "Francisco Padilla",
      "Claudia Fuentes",
      "Arturo Velazquez"
    ];

    // Lista de roles disponibles
    final List<String> roles = [
      AppStrings.superAdmin,
      AppStrings.departmentAdmin,
      AppStrings.editor,
      AppStrings.viewer,
      AppStrings.guest,
      AppStrings.user,
      AppStrings.admin,
    ];

    // Lista de departamentos disponibles
    final List<String> departments = [
      AppStrings.dgAdministracion,
      AppStrings.dgEgreso,
      AppStrings.dgIngreso,
      AppStrings.dgCuentaUnica,
      AppStrings.dgTecnologiaInformacion,
      AppStrings.dgPlanificacionAnalisisFinanciero,
      AppStrings.dgRecursosHumanos,
      AppStrings.dgInversionesYValores,
      AppStrings.dgConsultoriaJuridica,
    ];

    // Lista de cargos disponibles
    final List<String> positions = [
      AppStrings.coordinador,
      AppStrings.director_general,
      AppStrings.director_linea,
      AppStrings.asistente,
      AppStrings.analista,
      AppStrings.asesor,
      AppStrings.consultor,
      AppStrings.hp,
      AppStrings.otro,
    ];
    final sections = [
      AppStrings.alcaldias,
      AppStrings.organismosGobernacion,
      AppStrings.noticias,
      AppStrings.programacionFinanciera,
      AppStrings.resumenGestion,
      // Agrega más secciones según sea necesario
    ];

    for (int i = 0; i < 50; i++) {
      final user = User(
        email: 'user${i + 1}@example.com',
        password: 'Password123!',
        name: names[i % names.length],
        role: roles[i % roles.length],
        department: departments[i % departments.length],
        isActive: true,
        position: positions[i % positions.length],
      );

      // Guardar el usuario en la caja de Hive
      userBox.put(user);
      for (final section in sections) {
        final permiso = Permission(
          section: section,
          canCreate: false,
          canEdit: false,
          canDelete: false,
          canPublish: false,
        );
        permiso.user.target = user;
        permissionBox.put(permiso);
      }
    }


    final listRoles = [
      Role(name: 'SUPER_ADMIN'),
      Role(name: 'DEPARTMENT_ADMIN'),
      Role(name: 'EDITOR'),
      Role(name: 'VIEWER'),
      Role(name: 'GUEST'),
      Role(name: 'USER'),
      Role(name: 'ADMIN'),
    ];
    roleBox.putMany(listRoles);

    final cargos = [
      Cargo(name: 'COORDINADOR'),
      Cargo(name: 'DIRECTOR GENERAL'),
      Cargo(name: 'DIRECTOR DE LINEA'),
      Cargo(name: 'ASISTENTE'),
      Cargo(name: 'ANALISTA'),
      Cargo(name: 'ASESOR'),
      Cargo(name: 'CONSULTOR'),
      Cargo(name: 'HP'),
      Cargo(name: 'OTRO'),
    ];
    cargoBox.putMany(cargos);

    final direcciones = [
      Direccion(name: 'DIRECCIÓN GENERAL DE ADMINISTRACIÓN'),
      Direccion(name: 'DIRECCIÓN GENERAL DE EGRESO'),
      Direccion(name: 'DIRECCIÓN GENERAL DE INGRESO'),
      Direccion(name: 'DIRECCIÓN GENERAL DE CUENTA ÚNICA'),
      Direccion(name: 'DIRECCIÓN GENERAL DE TECNOLOGÍA DE INFORMACIÓN'),
      Direccion(name: 'DIRECCIÓN GENERAL DE PLANIFICACIÓN Y ANÁLISIS FINANCIERO'),
      Direccion(name: 'DIRECCIÓN GENERAL DE RECURSOS HUMANOS'),
      Direccion(name: 'DIRECCIÓN GENERAL DE INVERSIONES Y VALORES'),
      Direccion(name: 'DIRECCIÓN GENERAL DE CONSULTORÍA JURÍDICA'),
    ];
    direccionBox.putMany(direcciones);

    /**********************************************************************/
    // 1. Crear usuarios básicos
    final superAdmin = User(
      email: 'admin@example.com',
      password: 'Admin123',
      name: 'Administrador Principal',
      role: AppStrings.superAdmin,
      department: 'DGAdministracion',
      isActive: true,
      position: AppStrings.director_general,
    );
    userBox.put(superAdmin);
    for (final section in sections) {
      final permiso = Permission(
        section: section,
        canCreate: false,
        canEdit: false,
        canDelete: false,
        canPublish: false,
      );
      permiso.user.target = superAdmin;
      permissionBox.put(permiso);
    }



    final superAdmin2 = User(
      email: 'daniel@gmail.com',
      password: '123456',
      name: 'daniel quintero',
      role: AppStrings.superAdmin,
      department: AppStrings.dgTecnologiaInformacion,
      isActive: true,
      position: AppStrings.coordinador,
    );
    userBox.put(superAdmin2);
    for (final section in sections) {
      final permiso = Permission(
        section: section,
        canCreate: false,
        canEdit: false,
        canDelete: false,
        canPublish: false,
      );
      permiso.user.target = superAdmin2;
      permissionBox.put(permiso);
    }


    final editor = User(
      email: 'editor@example.com',
      password: 'Editor123',
      name: 'Editor General',
      role: AppStrings.editor,
      department: 'DGComunicacion',
      isActive: true,

    );
    userBox.put(editor);
    for (final section in sections) {
      final permiso = Permission(
        section: section,
        canCreate: false,
        canEdit: false,
        canDelete: false,
        canPublish: false,
      );
      permiso.user.target = editor;
      permissionBox.put(permiso);
    }

    // 3. Crear organismos con autor
    final organismo1 = OrganismoGobernacion(
      nombre: 'Ministerio de Hacienda',
      valor1: 100,
      valor2: 200,
      valor3: 300,
    );
    organismo1.autor.target = superAdmin;
    organismoBox.put(organismo1);
    final organismo2 = OrganismoGobernacion(
      nombre: 'Ministerio de Hacienda',
      valor1: 100,
      valor2: 200,
      valor3: 300,
    );
    organismo2.autor.target = superAdmin;
    organismoBox.put(organismo2);
    final organismo3 = OrganismoGobernacion(
      nombre: 'Ministerio de Hacienda',
      valor1: 100,
      valor2: 200,
      valor3: 300,
    );
    organismo3.autor.target = superAdmin;
    organismoBox.put(organismo3);

    // 4. Crear alcaldías con autor
    final alcaldia1 = Alcaldia(
      nombre: 'Alcaldía Central',
      valor1: 500,
      valor2: 600,
      valor3: 700,
    );
    alcaldia1.autor.target = superAdmin;
    alcaldiaBox.put(alcaldia1);

    // 5. Crear programación financiera con meses
    final programacion1 = ProgramacionFinanciera(
      titulo: 'Presupuesto Anual',
      descripcion: 'Presupuesto para el año fiscal 2023',
    );
    programacion1.autor.target = superAdmin;
    programacionBox.put(programacion1);

    // Meses relacionados
    final mes1 = Mes(nombre: 'Enero', valor: 1000000, tipo: 'PRESUPUESTO_INICIAL');
    mes1.programacionFinanciera.target = programacion1;
    mesBox.put(mes1);

    final mes2 = Mes(nombre: 'Febrero', valor: 950000, tipo: 'PRESUPUESTO_INICIAL');
    mes2.programacionFinanciera.target = programacion1;
    mesBox.put(mes2);

    // 6. Crear resumen de gestión
    final resumen1 = ResumenGestion(
      titulo: 'Informe Trimestral',
      descripcion: 'Resultados del primer trimestre',
      imagenUrl: 'https://example.com/informe.jpg',
    );
    resumen1.autor.target = superAdmin;
    resumenBox.put(resumen1);

    // 7. Crear noticias
    final noticia1 = Noticia(
      titulo: 'Nuevas iniciativas gubernamentales',
      contenido: 'El gobierno anuncia nuevas medidas económicas...',
    );
    noticia1.autor.target = editor;
    noticiaBox.put(noticia1);

    print('Seeder completado. Datos básicos creados.');
  }
}