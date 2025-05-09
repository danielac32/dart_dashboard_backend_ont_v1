
import '../../../model/model.dart';
import '../../../objectbox.g.dart';

class OrganismoRepository {
  final Store store;
  late final Box<OrganismoGobernacion> _organismoBox;

  OrganismoRepository(this.store) {
    _organismoBox = store.box<OrganismoGobernacion>();
  }

  int create(OrganismoGobernacion org) => _organismoBox.put(org);

  List<OrganismoGobernacion> getAll() => _organismoBox.getAll();

  bool update(OrganismoGobernacion org) => _organismoBox.put(org,mode: PutMode.update) > 0;

  bool delete(int id) => _organismoBox.remove(id);
}