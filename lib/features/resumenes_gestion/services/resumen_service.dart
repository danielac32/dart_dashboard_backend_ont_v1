
import '../../../model/model.dart';
import '../repository/resumen_repository.dart';

class ResumenService {
  final ResumenRepository _resumenRepository;

  // Constructor que recibe una instancia del repositorio
  ResumenService(this._resumenRepository);

  // Método para crear un nuevo resumen de gestión
  int createResumen(ResumenGestion resumen) {
    try {
      return _resumenRepository.create(resumen);
    } catch (e) {
      throw Exception('Error al crear el resumen de gestión: $e');
    }
  }

  // Método para obtener todos los resúmenes de gestión
  List<ResumenGestion> getAllResumenes() {
    try {
      return _resumenRepository.getAll();
    } catch (e) {
      throw Exception('Error al obtener los resúmenes de gestión: $e');
    }
  }

  // Método para actualizar un resumen de gestión existente
  bool updateResumen(ResumenGestion resumen) {
    try {
      return _resumenRepository.update(resumen);
    } catch (e) {
      throw Exception('Error al actualizar el resumen de gestión: $e');
    }
  }

  // Método para eliminar un resumen de gestión por su ID
  bool deleteResumen(int id) {
    try {
      return _resumenRepository.delete(id);
    } catch (e) {
      throw Exception('Error al eliminar el resumen de gestión: $e');
    }
  }

  // Método para consultar resúmenes de gestión por usuario
  List<ResumenGestion> getResumenesByUsuario(int usuarioId) {
    try {
      final resumenes = _resumenRepository.getAll();
      return resumenes.where((resumen) => resumen.autor.target?.id == usuarioId).toList();
    } catch (e) {
      throw Exception('Error al consultar resúmenes por usuario: $e');
    }
  }
}