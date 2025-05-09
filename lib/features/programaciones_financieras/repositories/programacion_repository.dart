import '../../../model/model.dart';
import '../../../objectbox.g.dart';

class ProgramacionRepository {
  final Store store;
  late final Box<ProgramacionFinanciera> _programacionBox;

  ProgramacionRepository(this.store) {
    _programacionBox = store.box<ProgramacionFinanciera>();
  }

  int create(ProgramacionFinanciera prog) => _programacionBox.put(prog);

  List<ProgramacionFinanciera> getAll() => _programacionBox.getAll();

  bool update(ProgramacionFinanciera prog) => _programacionBox.put(prog,mode: PutMode.update) > 0;

  bool delete(int id) => _programacionBox.remove(id);
}