import '../../../model/model.dart';
import '../repositories/programacion_repository.dart';

class ProgramacionService {
  final ProgramacionRepository _programacionRepository;

  // Constructor que recibe una instancia del repositorio
  ProgramacionService(this._programacionRepository);

  // Métodos para ProgramacionFinanciera

  int createProgramacion(ProgramacionFinanciera programacion) {
    try {
      return _programacionRepository.create(programacion);
    } catch (e) {
      throw Exception('Error al crear la programación financiera: $e');
    }
  }

  List<ProgramacionFinanciera> getAllProgramaciones() {
    try {
      return _programacionRepository.getAll();
    } catch (e) {
      throw Exception('Error al obtener las programaciones financieras: $e');
    }
  }

  bool updateProgramacion(ProgramacionFinanciera programacion) {
    try {
      return _programacionRepository.update(programacion);
    } catch (e) {
      throw Exception('Error al actualizar la programación financiera: $e');
    }
  }

  bool deleteProgramacion(int id) {
    try {
      return _programacionRepository.delete(id);
    } catch (e) {
      throw Exception('Error al eliminar la programación financiera: $e');
    }
  }

  // Métodos para Mes

  int createMes(Mes mes) {
    try {
      return _programacionRepository.createMes(mes);
    } catch (e) {
      throw Exception('Error al crear el mes: $e');
    }
  }

  List<Mes> getMesesByProgramacion(int programacionId) {
    try {
      return _programacionRepository.getMesesByProgramacion(programacionId);
    } catch (e) {
      throw Exception('Error al obtener los meses de la programación financiera: $e');
    }
  }

  bool updateMes(Mes mes) {
    try {
      return _programacionRepository.updateMes(mes);
    } catch (e) {
      throw Exception('Error al actualizar el mes: $e');
    }
  }

  bool deleteMes(int mesId) {
    try {
      return _programacionRepository.deleteMes(mesId);
    } catch (e) {
      throw Exception('Error al eliminar el mes: $e');
    }
  }

  bool addMesToProgramacion(int programacionId, Mes mes) {
    try {
      return _programacionRepository.addMesToProgramacion(programacionId, mes);
    } catch (e) {
      throw Exception('Error al agregar el mes a la programación financiera: $e');
    }
  }

  bool removeMesFromProgramacion(int programacionId, int mesId) {
    try {
      return _programacionRepository.removeMesFromProgramacion(programacionId, mesId);
    } catch (e) {
      throw Exception('Error al eliminar el mes de la programación financiera: $e');
    }
  }
}
/*
void main() {
  // Inicializar ObjectBox Store
  final store = Store(...); // Configura tu Store aquí
  final programacionRepository = ProgramacionRepository(store);
  final programacionService = ProgramacionService(programacionRepository);

  // Crear una nueva programación financiera
  final nuevaProgramacion = ProgramacionFinanciera(
    titulo: 'Programación Ejemplo',
    descripcion: 'Descripción de ejemplo',
  );
  final programacionId = programacionService.createProgramacion(nuevaProgramacion);
  print('Programación creada con ID: $programacionId');

  // Crear un nuevo mes
  final nuevoMes = Mes(
    nombre: 'Enero',
    valor: 5000,
    tipo: 'PRESUPUESTO_INICIAL',
  );
  final mesId = programacionService.createMes(nuevoMes);
  print('Mes creado con ID: $mesId');

  // Agregar el mes a la programación financiera
  final agregado = programacionService.addMesToProgramacion(programacionId, nuevoMes);
  print('Mes agregado a la programación: $agregado');

  // Obtener los meses de la programación financiera
  final meses = programacionService.getMesesByProgramacion(programacionId);
  print('Meses de la programación: $meses');

  // Eliminar el mes de la programación financiera
  final eliminado = programacionService.removeMesFromProgramacion(programacionId, mesId);
  print('Mes eliminado de la programación: $eliminado');

  // Eliminar el mes completamente
  final mesEliminado = programacionService.deleteMes(mesId);
  print('Mes eliminado: $mesEliminado');
}

 */
