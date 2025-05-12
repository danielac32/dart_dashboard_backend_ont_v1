import '../../../model/model.dart';
import '../repositories/noticia_repository.dart';

class NoticiaService {
  final NoticiaRepository _noticiaRepository;

  // Constructor que recibe una instancia del repositorio
  NoticiaService(this._noticiaRepository);

  // Método para crear una nueva noticia
  int create(Noticia noticia) {
    try {
      return _noticiaRepository.create(noticia);
    } catch (e) {
      throw Exception('Error al crear la noticia: $e');
    }
  }

  // Método para obtener todas las noticias
  List<Noticia> getAll() {
    try {
      return _noticiaRepository.getAll();
    } catch (e) {
      throw Exception('Error al obtener las noticias: $e');
    }
  }

  // Método para actualizar una noticia existente
  bool update(Noticia noticia) {
    try {
      return _noticiaRepository.update(noticia);
    } catch (e) {
      throw Exception('Error al actualizar la noticia: $e');
    }
  }

  // Método para eliminar una noticia por su ID
  bool delete(int id) {
    try {
      return _noticiaRepository.delete(id);
    } catch (e) {
      throw Exception('Error al eliminar la noticia: $e');
    }
  }
  List<Noticia> getNoticiasByUsuario(int usuarioId) {
    try {
      final noticias = _noticiaRepository.getAll();
      return noticias.where((noticia) => noticia.autor.target?.id == usuarioId).toList();
    } catch (e) {
      throw Exception('Error al consultar noticias por usuario: $e');
    }
  }
}