import '../../../model/model.dart';
import '../../../objectbox.g.dart';

class AlcaldiaRepository {
  final Store store;
  late final Box<Alcaldia> _alcaldiaBox;

  AlcaldiaRepository(this.store) {
    _alcaldiaBox = store.box<Alcaldia>();
  }
  int create(Alcaldia alcaldia) => _alcaldiaBox.put(alcaldia);

  List<Alcaldia> getAll() => _alcaldiaBox.getAll();

  bool update(Alcaldia alcaldia) => _alcaldiaBox.put(alcaldia,mode: PutMode.update) > 0;

  bool delete(int id) => _alcaldiaBox.remove(id);
}