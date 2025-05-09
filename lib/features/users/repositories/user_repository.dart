
import 'package:objectbox/objectbox.dart';

import '../../../model/model.dart';
import '../../../objectbox.g.dart';


class UserRepository {
  final Store store;
  late final Box<User> _userBox;

  UserRepository(this.store) {
    _userBox = store.box<User>();
  }
  List<User> getAll() => _userBox.getAll();

  int create(User user) => _userBox.put(user);

  bool update(User user) => _userBox.put(user,mode: PutMode.update) > 0;

  bool delete(int userId) => _userBox.remove(userId);

  User? getById(int id) => _userBox.get(id);

  User? getByEmail(String email) {
   /* if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return null;
    }*/
    final query = _userBox.query(User_.email.equals(email)).build();
    final user = query.findFirst();
    query.close();
    return user;
  }

  List<User> getByRole(String role) {
    final query = _userBox.query(User_.role.equals(role)).build();
    final users = query.find();
    query.close();
    return users;
  }

  List<User> getByDepartment(String department) {
    final query = _userBox.query(User_.department.equals(department)).build();
    final users = query.find();
    query.close();
    return users;
  }

}