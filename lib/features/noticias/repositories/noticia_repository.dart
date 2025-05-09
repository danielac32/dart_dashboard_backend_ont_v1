import '../../../model/model.dart';
import '../../../objectbox.g.dart';

class NoticiaRepository {
  final Store store;
  late final Box<Noticia> _noticiaBox;

  NoticiaRepository(this.store) {
    _noticiaBox = store.box<Noticia>();
  }

  int create(Noticia noticia) => _noticiaBox.put(noticia);

  List<Noticia> getAll() => _noticiaBox.getAll();

  bool update(Noticia noticia) => _noticiaBox.put(noticia,mode: PutMode.update) > 0;

  bool delete(int id) => _noticiaBox.remove(id);
}