
import '../../../model/model.dart';
import '../../../objectbox.g.dart';

class ResumenRepository {
  final Store store;
  late final Box<ResumenGestion> _resumenBox;

  ResumenRepository(this.store) {
    _resumenBox = store.box<ResumenGestion>();
  }
  int create(ResumenGestion resumen) => _resumenBox.put(resumen);

  List<ResumenGestion> getAll() => _resumenBox.getAll();

  bool update(ResumenGestion resumen) => _resumenBox.put(resumen,mode: PutMode.update) > 0;

  bool delete(int id) => _resumenBox.remove(id);
}