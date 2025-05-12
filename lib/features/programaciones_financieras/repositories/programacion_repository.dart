import '../../../model/model.dart';
import '../../../objectbox.g.dart';

class ProgramacionRepository {
  final Store store;
  late final Box<ProgramacionFinanciera> _programacionBox;
  late final Box<Mes> _mesBox;

  ProgramacionRepository(this.store) {
    _programacionBox = store.box<ProgramacionFinanciera>();
    _mesBox = store.box<Mes>();
  }

  // Métodos para ProgramacionFinanciera

  int create(ProgramacionFinanciera prog) => _programacionBox.put(prog);

  List<ProgramacionFinanciera> getAll() => _programacionBox.getAll();

  bool update(ProgramacionFinanciera prog) => _programacionBox.put(prog, mode: PutMode.update) > 0;

  bool delete(int id) => _programacionBox.remove(id);

  // Métodos para Mes

  int createMes(Mes mes) => _mesBox.put(mes);

  List<Mes> getMesesByProgramacion(int programacionId) {
    final programacion = _programacionBox.get(programacionId);
    return programacion?.meses.toList() ?? [];
  }

  bool updateMes(Mes mes) => _mesBox.put(mes, mode: PutMode.update) > 0;

  bool deleteMes(int mesId) => _mesBox.remove(mesId);

  bool addMesToProgramacion(int programacionId, Mes mes) {
    final programacion = _programacionBox.get(programacionId);
    if (programacion != null) {
      programacion.meses.add(mes);
      _programacionBox.put(programacion);
      return true;
    }
    return false;
  }

  bool removeMesFromProgramacion(int programacionId, int mesId) {
    final programacion = _programacionBox.get(programacionId);
    if (programacion != null) {
      final mes = _mesBox.get(mesId);
      if (mes != null) {
        programacion.meses.remove(mes);
        _programacionBox.put(programacion);
        return true;
      }
    }
    return false;
  }
}

