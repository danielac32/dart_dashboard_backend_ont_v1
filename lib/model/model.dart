

import 'package:objectbox/objectbox.dart';
import '../shared/app_strings.dart';




@Entity()
class Role{
  @Id()
  int id = 0;
  String name;
  Role({required this.name});

  Role copyWith({String? name}) {
    if (name != null) this.name = name;
    return this;
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}


@Entity()
class Cargo{
  @Id()
  int id = 0;
  String name;
  Cargo({required this.name});

  Cargo copyWith({String? name}) {
    if (name != null) this.name = name;
    return this;
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}


@Entity()
class Direccion{
  @Id()
  int id = 0;
  String name;
  Direccion({required this.name});

  Direccion copyWith({String? name}) {
    if (name != null) this.name = name;
    return this;
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}




@Entity()
class MetaDato{
  @Id()
  int id = 0;
  late int userId;
  String? telefono;
  String? centro_votacion;
  String? cedula;
  String? estado;
  String? municipio;
  String? parroquia;
  final createdAt = DateTime.now();
  late var updatedAt = DateTime.now();
  MetaDato({
        required this.userId,
        this.telefono,
        this.centro_votacion,
        this.cedula,
        this.estado,
        this.municipio,
        this.parroquia,
  });
}


@Entity()
class User {
  @Id()
  int id = 0;

  String email;
  String password;
  String name;
  String role; // SUPER_ADMIN, DEPARTMENT_ADMIN, EDITOR, VIEWER, GUEST
  String department; // DGAdministracion, DGEgreso, etc.
  bool isActive;
  String? profileImage; // Imagen de perfil (puede ser nulo)
  String position;

  final createdAt = DateTime.now();
  late var updatedAt = DateTime.now();

  @Backlink('user')
  final permissions = ToMany<Permission>();

  @Backlink('autor')
  final organismosGobernacion = ToMany<OrganismoGobernacion>();

  @Backlink('autor')
  final alcaldias = ToMany<Alcaldia>();

  @Backlink('autor')
  final programacionesFinancieras = ToMany<ProgramacionFinanciera>();

  @Backlink('autor')
  final resumenesGestion = ToMany<ResumenGestion>();

  @Backlink('autor')
  final noticias = ToMany<Noticia>();

  User({
    required this.email,
    required this.password,
    required this.name,
    this.role = AppStrings.user,
    this.isActive=true,
    this.position=AppStrings.analista,
    this.profileImage,
    required this.department,
  });


  User copyWith({
    String? email,
    String? password,
    String? name,
    String? role,
    String? department,
    bool? isActive,
    String? position,
    String? profileImage
  }) {
    // Actualizamos los campos de la instancia actual
    if (email != null) this.email = email;
    if (password != null) this.password = password;
    if (name != null) this.name = name;
    if (role != null) this.role = role;
    if (department != null) this.department = department;
    if( isActive != null) this.isActive=isActive;
    if (position != null) this.position=position;
    if( profileImage != null) this.profileImage=profileImage;
    // Actualizamos la fecha de modificación
    updatedAt = DateTime.now();
    // Devolvemos la misma instancia
    return this;
  }

  // Método toJson() para serializar el objeto User

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password, // Considera no incluir la contraseña por seguridad
      'name': name,
      'role': role,
      'department': department,
      'createdAt': createdAt.toIso8601String(), // Serializa la fecha como String
      'updatedAt': updatedAt.toIso8601String(), // Serializa la fecha como String
      'isActive': isActive,
      'position': position,
      'profileImage': profileImage
      /* 'permissions': permissions.map((permission) => permission.toJson()).toList(), // Serializa las relaciones
      'organismosGobernacion': organismosGobernacion.map((organismo) => organismo.toJson()).toList(),
      'alcaldias': alcaldias.map((alcaldia) => alcaldia.toJson()).toList(),
      'programacionesFinancieras': programacionesFinancieras.map((programacion) => programacion.toJson()).toList(),
      'resumenesGestion': resumenesGestion.map((resumen) => resumen.toJson()).toList(),
      'noticias': noticias.map((noticia) => noticia.toJson()).toList(),*/
    };
  }
}

@Entity()
class Permission {
  @Id()
  int id = 0;

  final user = ToOne<User>();

  String section; // ORGANISMOS_GOBERNACION, ALCALDIAS, etc.

  bool canCreate = false;
  bool canEdit = false;
  bool canDelete = false;
  bool canPublish = false;

  final createdAt = DateTime.now();
  final updatedAt = DateTime.now();

  Permission({
    required this.section,
    this.canCreate = false,
    this.canEdit = false,
    this.canDelete = false,
    this.canPublish = false,
  });

  Permission copyWith({
    String? section,
    bool? canCreate,
    bool? canEdit,
    bool? canDelete,
    bool? canPublish,
  }) {
    return Permission(
      section: section ?? this.section,
      canCreate: canCreate ?? this.canCreate,
      canEdit: canEdit ?? this.canEdit,
      canDelete: canDelete ?? this.canDelete,
      canPublish: canPublish ?? this.canPublish,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'section':section,
      'canCreate': canCreate,
      'canEdit': canEdit, // Considera no incluir la contraseña por seguridad
      'canDelete': canDelete,
      'canPublish': canPublish,
    };
  }
  @override
  String toString() {
    // TODO: implement toString
    return "$id - $section - $canCreate - $canDelete - $canEdit - $canPublish";
  }
}

@Entity()
class OrganismoGobernacion {
  @Id()
  int id = 0;

  String nombre;
  int valor1;
  int valor2;
  int valor3;

  final autor = ToOne<User>();

  final createdAt = DateTime.now();
  final updatedAt = DateTime.now();

  OrganismoGobernacion({
    required this.nombre,
    required this.valor1,
    required this.valor2,
    required this.valor3,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre':nombre,
      'valor1': valor1,
      'valor2': valor2, // Considera no incluir la contraseña por seguridad
      'valor3': valor3,
    };
  }
}

@Entity()
class Alcaldia {
  @Id()
  int id = 0;

  String nombre;
  int valor1;
  int valor2;
  int valor3;

  final autor = ToOne<User>();

  final createdAt = DateTime.now();
  final updatedAt = DateTime.now();

  Alcaldia({
    required this.nombre,
    required this.valor1,
    required this.valor2,
    required this.valor3,
  });
}

@Entity()
class ProgramacionFinanciera {
  @Id()
  int id = 0;

  String titulo;
  String? descripcion;

  final autor = ToOne<User>();
  final meses = ToMany<Mes>();

  final createdAt = DateTime.now();
  final updatedAt = DateTime.now();

  ProgramacionFinanciera({
    required this.titulo,
    this.descripcion,
  });
}

@Entity()
class Mes {
  @Id()
  int id = 0;

  String nombre;
  double valor;
  String tipo; // PRESUPUESTO_INICIAL, PRESUPUESTO_FINAL, GASTO_REAL

  final programacionFinanciera = ToOne<ProgramacionFinanciera>();

  final createdAt = DateTime.now();
  final updatedAt = DateTime.now();

  Mes({
    required this.nombre,
    required this.valor,
    required this.tipo,
  });
}

@Entity()
class ResumenGestion {
  @Id()
  int id = 0;

  String titulo;
  String descripcion;
  String imagenUrl;

  final autor = ToOne<User>();

  final createdAt = DateTime.now();
  final updatedAt = DateTime.now();

  ResumenGestion({
    required this.titulo,
    required this.descripcion,
    required this.imagenUrl,
  });
  Map<String, dynamic> toJson() {
    return {
      'titulo':titulo,
      'descripcion': descripcion,
      'imagenUrl': imagenUrl, // Considera no incluir la contraseña por seguridad
    };
  }
}

@Entity()
class Noticia {
  @Id()
  int id = 0;

  String titulo;
  String contenido;
  String? imagenUrl;

  final autor = ToOne<User>();

  final createdAt = DateTime.now();
  final updatedAt = DateTime.now();

  Noticia({
    required this.titulo,
    required this.contenido,
    this.imagenUrl,
  });
  Map<String, dynamic> toJson() {
    return {
      'titulo':titulo,
      'contenido': contenido,
      'imagenUrl': imagenUrl, // Considera no incluir la contraseña por seguridad
    };
  }
}