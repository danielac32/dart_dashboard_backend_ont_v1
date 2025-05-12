import '../../../model/model.dart';
import '../repositories/organismo_repository.dart';

class OrganismoService {
  final OrganismoRepository _organismoRepository;

  // Constructor que recibe una instancia del repositorio
  OrganismoService(this._organismoRepository);

  // Método para crear un nuevo organismo
  int create(OrganismoGobernacion organismo) {
    try {
      return _organismoRepository.create(organismo);
    } catch (e) {
      throw Exception('Error al crear el organismo: $e');
    }
  }

  // Método para obtener todos los organismos
  List<OrganismoGobernacion> getAll() {
    try {
      return _organismoRepository.getAll();
    } catch (e) {
      throw Exception('Error al obtener los organismos: $e');
    }
  }

  // Método para actualizar un organismo existente
  bool update(OrganismoGobernacion organismo) {
    try {
      return _organismoRepository.update(organismo);
    } catch (e) {
      throw Exception('Error al actualizar el organismo: $e');
    }
  }

  // Método para eliminar un organismo por su ID
  bool delete(int id) {
    try {
      return _organismoRepository.delete(id);
    } catch (e) {
      throw Exception('Error al eliminar el organismo: $e');
    }
  }
  List<OrganismoGobernacion> getOrganismosByUsuario(int usuarioId) {
    try {
      final organismos = _organismoRepository.getAll();
      return organismos.where((org) => org.autor.target?.id == usuarioId).toList();
    } catch (e) {
      throw Exception('Error al consultar organismos por usuario: $e');
    }
  }
}