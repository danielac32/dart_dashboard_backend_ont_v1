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

    // Limpiar datos existentes (opcional)
    userBox.removeAll();
    permissionBox.removeAll();
    organismoBox.removeAll();
    alcaldiaBox.removeAll();
    programacionBox.removeAll();
    mesBox.removeAll();
    resumenBox.removeAll();
    noticiaBox.removeAll();

    // 1. Crear usuarios básicos
    final superAdmin = User(
      email: 'admin@example.com',
      password: 'Admin123',
      name: 'Administrador Principal',
      role: AppStrings.superAdmin,
      department: 'DGAdministracion',
    );
    userBox.put(superAdmin);

    final editor = User(
      email: 'editor@example.com',
      password: 'Editor123',
      name: 'Editor General',
      role: AppStrings.editor,
      department: 'DGComunicacion',
    );
    userBox.put(editor);

    // 2. Crear permisos directamente relacionados
    final permisoAdmin = Permission(
      section: AppStrings.organismosGobernacion,
      canCreate: true,
      canEdit: true,
      canDelete: true,
      canPublish: true,
    );
    permisoAdmin.user.target = superAdmin;
    permissionBox.put(permisoAdmin);

    final permisoEditor = Permission(
      section: AppStrings.noticias,
      canCreate: true,
      canEdit: true,
      canDelete: false,
      canPublish: false,
    );
    permisoEditor.user.target = editor;
    permissionBox.put(permisoEditor);

    // 3. Crear organismos con autor
    final organismo1 = OrganismoGobernacion(
      nombre: 'Ministerio de Hacienda',
      valor1: 100,
      valor2: 200,
      valor3: 300,
    );
    organismo1.autor.target = superAdmin;
    organismoBox.put(organismo1);

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