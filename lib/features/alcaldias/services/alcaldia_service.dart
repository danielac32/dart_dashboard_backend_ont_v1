import 'package:dart_dashboard_backend_ont_v1/features/alcaldias/repositories/alcaldia_repository.dart';

import '../../../model/model.dart';

class AlcaldiaService {
  final AlcaldiaRepository _alcaldiaRepository;

  // Constructor que recibe una instancia del repositorio
  AlcaldiaService(this._alcaldiaRepository);

  // Método para crear una nueva alcaldía
  int create(Alcaldia alcaldia) {
    try {
      return _alcaldiaRepository.create(alcaldia);
    } catch (e) {
      throw Exception('Error al crear la alcaldía: $e');
    }
  }

  // Método para obtener todas las alcaldías
  List<Alcaldia> getAll() {
    try {
      return _alcaldiaRepository.getAll();
    } catch (e) {
      throw Exception('Error al obtener las alcaldías: $e');
    }
  }

  // Método para actualizar una alcaldía existente
  bool update(Alcaldia alcaldia) {
    try {
      return _alcaldiaRepository.update(alcaldia);
    } catch (e) {
      throw Exception('Error al actualizar la alcaldía: $e');
    }
  }

  // Método para eliminar una alcaldía por su ID
  bool delete(int id) {
    try {
      return _alcaldiaRepository.delete(id);
    } catch (e) {
      throw Exception('Error al eliminar la alcaldía: $e');
    }
  }
  // Método para consultar alcaldías por usuario
  List<Alcaldia> getAlcaldiasByUsuario(int usuarioId) {
    try {
      final alcaldias = _alcaldiaRepository.getAll();
      return alcaldias.where((alcaldia) => alcaldia.autor.target?.id == usuarioId).toList();
    } catch (e) {
      throw Exception('Error al consultar alcaldías por usuario: $e');
    }
  }
}